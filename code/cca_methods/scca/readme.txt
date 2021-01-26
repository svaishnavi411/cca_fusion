Structured Sparse Canonical Correlation Analysis with Overlapping Group Lasso Penalty

Paper: Structured Sparse Canonical Correlation Analysis by Xi Chen, Han Liu and Jaime G. Carbonell in AISTATS 2012.(SSCCA)

Functions Related to Excessive Gap with Overlapping Group Lasso Penalty:
Main Algorithm: group_exgap.m.
Related functions: gentoy.m (generate toy data), pre_group.m (preprocessing), shrink_group.m (shrinkage operator), cal2norm.m
Please run test_group_exgap.m to test the performance of the algorithm [Algorithm 1 in Section 3.1 in SSCCA and Section 5.1]

Functions Related to L1-Sparse CCA: see the paper [A penalized matrix decomposition, with applications to sparse principal components and canonical correlation analysis] by DANIELA M. WITTEN,  ROBERT TIBSHIRANI and TREVOR HASTIE in Biostatistics.
maxL1L2.m implements Lemma 2.2. in the paper (use BinarySearch.m, soft_threshold.c (soft thresholding operator) and projl2.m (projection on L2-ball))
Please mex soft_threshold.c beforing using it (run install_mex.m)

SparseCCAGroup.m implements Group Structured Sparse CCA (alternating optimization)
Please run test_group_CCA.m to test a toy example of Group Structured Sparse CCA.

Please cite if you use the code in your research. 

@INPROCEEDINGS{Chen:AISTATS:12,
  author = {Xi Chen and Han Liu and Jaime Carbonell},
  title = {Structured Sparse Canonical Correlation Analysis},
  booktitle = Conference on Artificial Intelligence and Statistics (AISTATS)},
  year = {2012}  
}

For any comment or question, please contact: xichen@cs.cmu.edu