from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import accuracy_score, f1_score, precision_score, recall_score
from sklearn.metrics import roc_auc_score
from sklearn.ensemble import RandomForestClassifier
import numpy as np
import pandas as pd
from glob import glob


def load_clinical(clinical_df, patients):
    threshold = 365
    binary = {}
    events = {}
    times = {}

    itr = 0
    for pid in patients:
        itr += 1
        if pid not in clinical_df.index:
            print(pid)
        curr_status = clinical_df.loc[pid]['vital_status']
        num_days = 0
        if curr_status == 'Alive':
            num_days = clinical_df.loc[pid]['last_contact_days_to']
            if num_days in ['[Discrepancy]', '[Not Available]'] :
                continue
            events[pid] = 0
            times[pid] = num_days
            binary[pid] = 1*(int(num_days) > threshold)
        elif curr_status == 'Dead':
            num_days = clinical_df.loc[pid]['death_days_to']
            if num_days == '[Not Available]':
                continue
            events[pid] = 1
            times[pid] = num_days
            binary[pid] = 1*(int(num_days) > threshold)
        else:
            print(pid)
            
    labels = []
    for idx in events.keys():
        labels.append(tuple((bool(int(events[idx])), int(times[idx]))))
    dt1=np.dtype(('bool,float'))
    labels = np.array(labels, dtype=dt1)

    return binary, events, times, labels

def get_patients_info(clinical_dir, data_loc, num_genes, fold_num):

    data_file = glob(clinical_dir + 'brca' + '/*clinical_patient*')[0]

    clinical_df = pd.read_csv(data_file, sep='\t')
    clinical_df = clinical_df.set_index('bcr_patient_barcode')

    # Load patients
    train_patients = list(pd.read_csv(data_loc + 'train/' + str(num_genes) + 
                                      "/" + str(fold_num) + '/patients.csv', header=None)[0])
    train_patients = ['-'.join(p.split('-')[:-1]) for p in train_patients]

    valid_patients = list(pd.read_csv(data_loc + 'valid/' + str(num_genes) + 
                                      "/" + str(fold_num) + '/patients.csv', header=None)[0])
    valid_patients = ['-'.join(p.split('-')[:-1]) for p in valid_patients]

    test_patients = list(pd.read_csv(data_loc + 'test/' + str(num_genes) + 
                                     "/" + str(fold_num) + '/patients.csv', header=None)[0])
    test_patients = ['-'.join(p.split('-')[:-1]) for p in test_patients]

    binary_train, events_train, times_train, labels_train = load_clinical(clinical_df, train_patients)
    binary_valid, events_valid, times_valid, labels_valid = load_clinical(clinical_df, valid_patients)
    binary_test, events_test, times_test, labels_test = load_clinical(clinical_df, test_patients)

    binary_train = list(binary_train.values())
    binary_valid = list(binary_valid.values())
    binary_test = list(binary_test.values())

    # Genomics and Imaging Load
    genomics_train = np.array(pd.read_csv(data_loc + 'train/' + str(num_genes) + 
                                          "/" + str(fold_num) + '/genes.csv', header=None));
    imaging_train = np.array(pd.read_csv(data_loc + 'train/' + str(num_genes) + 
                                         "/" + str(fold_num) +'/image.csv', header=None));

    genomics_train = np.asarray(genomics_train, np.float64)
    imaging_train = np.asarray(imaging_train, np.float64)

    genomics_valid = np.array(pd.read_csv(data_loc + 'valid/' + str(num_genes) +
                                          "/" + str(fold_num) + '/genes.csv', header=None));
    imaging_valid = np.array(pd.read_csv(data_loc + 'valid/' + str(num_genes) + 
                                         "/" + str(fold_num) +'/image.csv', header=None));

    genomics_valid = np.asarray(genomics_valid, np.float64)
    imaging_valid = np.asarray(imaging_valid, np.float64)

    genomics_test = np.array(pd.read_csv(data_loc + 'test/' + str(num_genes) + 
                                         "/" + str(fold_num) + '/genes.csv', header=None));
    imaging_test = np.array(pd.read_csv(data_loc + 'test/' + str(num_genes) + 
                                        "/" + str(fold_num) +'/image.csv', header=None));

    genomics_test = np.asarray(genomics_test, np.float64)
    imaging_test = np.asarray(imaging_test, np.float64)

    genomics = {"train": genomics_train,
                "valid": genomics_valid,
                "test" : genomics_test}
    
    imaging =  {"train": imaging_train,
                "valid": imaging_valid,
                "test" : imaging_test}
    
    binary =   {"train": binary_train,
                "valid": binary_valid,
                "test" : binary_test}

    return genomics, imaging, binary

def compute_metrics(y_true, y_pred, y_pred_score):
    y_pred = list(map(bool, y_pred))
    acc = accuracy_score(y_true, y_pred)
    prec = precision_score(y_true, y_pred, average="weighted", zero_division=0)
    rec = recall_score(y_true, y_pred, average="weighted")
    f1 = f1_score(y_true, y_pred, average="weighted")
    auc = roc_auc_score(y_true, y_pred_score[:,1], average="weighted")    
    return [acc, prec, rec, f1, auc]

def RF_trainer(X_train, X_valid, Y_train, Y_valid, d=50):
    RF = RandomForestClassifier(max_depth=d, random_state=42, n_estimators=64)
    clf = make_pipeline(StandardScaler(), RF)
    clf.fit(X_train, Y_train)

    Y_pred = clf.predict(X_valid)
    Y_pred_score = clf.predict_proba(X_valid)
    return compute_metrics(Y_valid, Y_pred, Y_pred_score), Y_pred, Y_pred_score
    
def RF_LF_trainer(X1_train, X1_valid, X2_train, X2_valid, Y_train, Y_valid, d=15):
    RF = RandomForestClassifier(max_depth=d, random_state=42, n_estimators=64)
    clf1 = make_pipeline(StandardScaler(), RF)
    clf1.fit(X1_train, Y_train)

    Y1_pred = clf1.predict(X1_valid)
    Y1_pred_score = clf1.predict_proba(X1_valid)
    
    RF = RandomForestClassifier(max_depth=d, random_state=42, n_estimators=64)
    clf2 = make_pipeline(StandardScaler(), RF)
    clf2.fit(X2_train, Y_train)

    Y2_pred = clf2.predict(X2_valid)
    Y2_pred_score = clf2.predict_proba(X2_valid)
    
    Y_pred = 1*(Y1_pred + Y2_pred > 0)
    Y_pred_score = 0.5*(Y1_pred_score + Y2_pred_score)
    return compute_metrics(Y_valid, Y_pred, Y_pred_score), Y_pred, Y_pred_score