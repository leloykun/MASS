SRC=en
TGT=zh

N_THREADS=8

UNSUP_PATH=$PWD/../MASS-unsupNMT
SUP_PATH=$PWD/../MASS-supNMT

DATA_PATH=$PWD/raw
SAVE_PATH=$PWD/processed
UNSUP_PROC_PATH=$UNSUP_PATH/data/processed/$SRC-$TGT
SUP_PROC_PATH=$SUP_PATH/data/processed

mkdir $SAVE_PATH

# tools
TOOLS_PATH=$UNSUP_PATH/tools
FASTBPE_DIR=$TOOLS_PATH/fastBPE
FASTBPE=$TOOLS_PATH/fastBPE/fast
MOSES=$TOOLS_PATH/mosesdecoder
REPLACE_UNICODE_PUNCT=$MOSES/scripts/tokenizer/replace-unicode-punctuation.perl
NORM_PUNC=$MOSES/scripts/tokenizer/normalize-punctuation.perl
REM_NON_PRINT_CHAR=$MOSES/scripts/tokenizer/remove-non-printing-char.perl
TOKENIZER=$MOSES/scripts/tokenizer/tokenizer.perl

# query & answer files
SRC_QUERY=$DATA_PATH/test.$SRC
SRC_QUERY_CLEAN=$SRC_QUERY.prep
SRC_QUERY_TOK=$SRC_QUERY.tok
SRC_QUERY_BPE=$SAVE_PATH/test.$SRC-$TGT.$SRC

TGT_QUERY=$DATA_PATH/test.$TGT
TGT_QUERY_CLEAN=$TGT_QUERY.prep
TGT_QUERY_TOK=$TGT_QUERY.tok
TGT_QUERY_BPE=$SAVE_PATH/test.$SRC-$TGT.$TGT

# BPE / vocab files
BPE_CODES=$UNSUP_PROC_PATH/codes
SRC_VOCAB=$UNSUP_PROC_PATH/vocab.$SRC
TGT_VOCAB=$UNSUP_PROC_PATH/vocab.$TGT
FULL_VOCAB=$UNSUP_PROC_PATH/vocab.$SRC-$TGT


echo $TOOLS_PATH
echo $FASTBPE
echo $BPE_CODES
echo $SRC_VOCAB
echo $TGT_VOCAB
echo $FULL_VOCAB
echo "[====================================================]"
echo "[====================================================]"

# cleanup
if ! [[ -f "$SRC_QUERY_CLEAN" ]]; then
  echo "Clean up $SRC & $TGT query"
  eval "cat $SRC_QUERY | python3 $PWD/cleanup.py > $SRC_QUERY_CLEAN"
  eval "cat $TGT_QUERY | python3 $PWD/cleanup.py > $TGT_QUERY_CLEAN"
fi
echo "$SRC query data cleaned up in: $SRC_QUERY_CLEAN"
echo "$TGT query data cleaned up in: $TGT_QUERY_CLEAN"
echo "[====================================================]"
echo "[====================================================]"

# tokenize queries
if ! [[ -f "$SRC_QUERY_TOK" ]]; then
  echo "Tokenizing $SRC..."
  eval "cat $SRC_QUERY_CLEAN | $REPLACE_UNICODE_PUNCT | $NORM_PUNC -l $SRC | $REM_NON_PRINT_CHAR | \
  python3 $TOOLS_PATH/lowercase_and_remove_accent.py | \
  $TOKENIZER -no-escape -threads $N_THREADS -l $SRC > $SRC_QUERY_TOK"

  eval "cat $TGT_QUERY_CLEAN | $REPLACE_UNICODE_PUNCT | $NORM_PUNC | $REM_NON_PRINT_CHAR | \
  python3 $TOOLS_PATH/lowercase_and_remove_accent.py | \
  $TOOLS_PATH/stanford-segmenter-*/segment.sh pku /dev/stdin UTF-8 0 | \
  $REPLACE_UNICODE_PUNCT | $NORM_PUNC -l $TGT | $REM_NON_PRINT_CHAR > $TGT_QUERY_TOK"
fi
echo "$SRC query data tokenized in: $SRC_QUERY_TOK"
echo "$TGT query data tokenized in: $TGT_QUERY_TOK"
echo "[====================================================]"
echo "[====================================================]"

# apply BPE codes
if ! [[ -f "$SRC_QUERY_BPE" && -f "$TGT_QUERY_BPE" ]]; then
  echo "Applying BPE codes..."
  $FASTBPE applybpe $SRC_QUERY_BPE $SRC_QUERY_TOK $BPE_CODES
  $FASTBPE applybpe $TGT_QUERY_BPE $TGT_QUERY_TOK $BPE_CODES
fi
echo "$SRC query data applied BPE in: $SRC_QUERY_BPE"
echo "$TGT query data applied BPE in: $TGT_QUERY_BPE"
echo "[====================================================]"
echo "[====================================================]"

# binarize data
if ! [[ -f "$SRC_QUERY_BPE.pth" && -f "$TGT_QUERY_BPE.pth" ]]; then
  echo "Binarizing..."
  python3 $UNSUP_PATH/preprocess.py $FULL_VOCAB $SRC_QUERY_BPE
  python3 $UNSUP_PATH/preprocess.py $FULL_VOCAB $TGT_QUERY_BPE
fi
echo $SRC query data binarized in: $SRC_QUERY_BPE.pth
echo $TGT query data binarized in: $TGT_QUERY_BPE.pth
echo "[====================================================]"
echo "[====================================================]"

if [[ -f "$SRC_QUERY_BPE.pth" && -f "$TGT_QUERY_BPE.pth" ]]; then
  fairseq-preprocess \
    --user-dir ../MASS-supNMT/mass \
    --task xmasked_seq2seq \
    --source-lang $SRC --target-lang $TGT \
    --testpref $SAVE_PATH/test.$SRC-$TGT \
    --destdir $SAVE_PATH \
    --srcdict $SRC_VOCAB \
    --tgtdict $TGT_VOCAB
else
  echo "Not proprocessed"
fi
echo "[====================================================]"
echo "[====================================================]"

echo "DONE!!"
