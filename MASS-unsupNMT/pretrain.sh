python3 train.py                                     \
--dump_path ./dumped/                                \
--exp_name unsupMT_zhen                              \
--save_periodic 1                                    \
\
--encoder_only false                                 \
\
--emb_dim 384                                        \
--n_layers 6                                         \
--n_dec_layers 6                                     \
--n_heads 6                                          \
--dropout 0.1                                        \
--attention_dropout 0.1                              \
--gelu_activation true                               \
\
--word_mass 0.5                                      \
\
--data_path ./data/processed/en-zh/                  \
--lgs 'en-zh'                                        \
\
--bptt 64                                            \
--min_len 5                                          \
--max_len 64                                         \
--tokens_per_batch 3000                              \
\
--optimizer adam_inverse_sqrt,beta1=0.9,beta2=0.98,lr=0.0001 \
--epoch_size 50000                                   \
--max_epoch 100                                      \
\
--mass_steps 'en,zh'                                 \
\
--eval_bleu true                                     \
