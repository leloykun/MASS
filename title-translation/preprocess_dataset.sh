SRC=${1:-zh}
TGT=${2:-en}

N_THREADS=8

UNSUP_PATH=$PWD/../MASS-unsupNMT
SUP_PATH=$PWD/../MASS-supNMT

DATA_PATH=$PWD/raw
SAVE_PATH=$PWD/processed
UNSUP_PROC_PATH=$UNSUP_PATH/data/processed/$TGT-$SRC
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
QUERY=$DATA_PATH/test.$SRC
QUERY_CLEAN=$QUERY.prep
QUERY_TOK=$QUERY.tok
QUERY_BPE=$SAVE_PATH/test.$SRC

# BPE / vocab files
BPE_CODES=$UNSUP_PROC_PATH/codes
SRC_VOCAB=$UNSUP_PROC_PATH/vocab.$SRC
TGT_VOCAB=$UNSUP_PROC_PATH/vocab.$TGT
FULL_VOCAB=$UNSUP_PROC_PATH/vocab.$TGT-$SRC


echo $TOOLS_PATH
echo $FASTBPE
echo $BPE_CODES
echo $SRC_VOCAB
echo $TGT_VOCAB
echo $FULL_VOCAB
echo "[====================================================]"
echo "[====================================================]"

# cleanup
if ! [[ -f "$QUERY_CLEAN" ]]; then
  echo "Clean up $SRC query"
  eval "cat $QUERY | python3 $PWD/cleanup.py > $QUERY_CLEAN"
fi
echo "$SRC query data cleaned up in: $QUERY_CLEAN"
echo "[====================================================]"
echo "[====================================================]"

# tokenize queries
if ! [[ -f "$QUERY_TOK" ]]; then
  echo "Tokenize $SRC query"
  if [ "$SRC" = "zh" ]; then
    eval "cat $QUERY_CLEAN | $REPLACE_UNICODE_PUNCT | $NORM_PUNC | $REM_NON_PRINT_CHAR | \
    python3 $TOOLS_PATH/lowercase_and_remove_accent.py | \
    $TOOLS_PATH/stanford-segmenter-*/segment.sh pku /dev/stdin UTF-8 0 | \
    $REPLACE_UNICODE_PUNCT | $NORM_PUNC -l $SRC | $REM_NON_PRINT_CHAR > $QUERY_TOK"
  else
    eval "cat $QUERY_CLEAN | $REPLACE_UNICODE_PUNCT | $NORM_PUNC -l $SRC | $REM_NON_PRINT_CHAR | \
    $TOKENIZER -no-escape -threads $N_THREADS -l $SRC > QUERY_TOK"
  fi
fi
echo "$SRC query data tokenized in: $QUERY_TOK"
echo "[====================================================]"
echo "[====================================================]"

# apply BPE codes
if ! [[ -f "$QUERY_BPE" ]]; then
  echo "Applying $SRC BPE codes..."
  $FASTBPE applybpe $QUERY_BPE $QUERY_TOK $BPE_CODES
fi
echo "$SRC query data applied BPE in: $QUERY_BPE"
echo "[====================================================]"
echo "[====================================================]"

# binarize data
if ! [[ -f "$QUERY_BPE.pth" ]]; then
  echo "Binarizing $SRC data..."
  python3 $UNSUP_PATH/preprocess.py $FULL_VOCAB $QUERY_BPE
fi
echo $SRC query data binarized in: $QUERY_BPE.pth
echo "[====================================================]"
echo "[====================================================]"

if [[ -f "$QUERY_BPE.pth" ]]; then
  echo "Preprocessing"
  fairseq-preprocess \
    --task cross_lingual_lm \
    --srcdict $SRC_VOCAB \
    --only-source \
    --testpref $SAVE_PATH/test \
    --destdir $SAVE_PATH/ \
    --workers 20 \
    --source-lang $SRC

  mv $SAVE_PATH/test.$SRC-None.$SRC.bin $SAVE_PATH/test.$SRC.bin
  mv $SAVE_PATH/test.$SRC-None.$SRC.idx $SAVE_PATH/test.$SRC.idx
else
  echo "Not proprocessed"
fi
echo "[====================================================]"
echo "[====================================================]"

cp $SUP_PROC_PATH/dict.en.txt $SAVE_PATH/dict.en.txt
cp $SUP_PROC_PATH/dict.zh.txt $SAVE_PATH/dict.zh.txt

echo "DONE!!"
