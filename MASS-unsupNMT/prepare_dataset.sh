SRC=$1
TGT=$2
CODES=$3

MAIN_PATH=$PWD
TOOLS_PATH=$PWD/tools
DATA_PATH=$PWD/data
MONO_PATH=$DATA_PATH/mono
PARA_PATH=$DATA_PATH/para
PROC_PATH=$DATA_PATH/processed/$SRC-$TGT

FASTBPE_DIR=$TOOLS_PATH/fastBPE
FASTBPE=$TOOLS_PATH/fastBPE/fast

MOSES=$TOOLS_PATH/mosesdecoder
REPLACE_UNICODE_PUNCT=$MOSES/scripts/tokenizer/replace-unicode-punctuation.perl
NORM_PUNC=$MOSES/scripts/tokenizer/normalize-punctuation.perl
REM_NON_PRINT_CHAR=$MOSES/scripts/tokenizer/remove-non-printing-char.perl

echo "Create paths..."
echo $MAIN_PATH
echo $TOOLS_PATH
echo $DATA_PATH
echo $MONO_PATH
echo $PARA_PATH
echo $PROC_PATH

mkdir -p $TOOLS_PATH
mkdir -p $DATA_PATH
mkdir -p $MONO_PATH
mkdir -p $PARA_PATH
mkdir -p $PROC_PATH

# ALL raw and tokenized sentences
ALL_SRC_ALL=$DATA_PATH/all.$SRC
ALL_TGT_ALL=$DATA_PATH/all.$TGT

ALL_SRC_ALL_TOK=$ALL_SRC_ALL.tok
ALL_TGT_ALL_TOK=$ALL_TGT_ALL.tok

# MONO raw and tokenized sentences
MONO_SRC_TRAIN=$MONO_PATH/train.$SRC
MONO_TGT_TRAIN=$MONO_PATH/train.$TGT
MONO_SRC_VALID=$MONO_PATH/valid.$SRC
MONO_TGT_VALID=$MONO_PATH/valid.$TGT
MONO_SRC_TEST=$MONO_PATH/test.$SRC
MONO_TGT_TEST=$MONO_PATH/test.$TGT

MONO_SRC_TRAIN_TOK=$MONO_SRC_TRAIN.tok
MONO_TGT_TRAIN_TOK=$MONO_TGT_TRAIN.tok
MONO_SRC_VALID_TOK=$MONO_SRC_VALID.tok
MONO_TGT_VALID_TOK=$MONO_TGT_VALID.tok
MONO_SRC_TEST_TOK=$MONO_SRC_TEST.tok
MONO_TGT_TEST_TOK=$MONO_TGT_TEST.tok

# PARA raw and tokenized sentences
PARA_SRC_TRAIN=$PARA_PATH/train.$SRC
PARA_TGT_TRAIN=$PARA_PATH/train.$TGT
PARA_SRC_VALID=$PARA_PATH/valid.$SRC
PARA_TGT_VALID=$PARA_PATH/valid.$TGT
PARA_SRC_TEST=$PARA_PATH/test.$SRC
PARA_TGT_TEST=$PARA_PATH/test.$TGT

PARA_SRC_TRAIN_TOK=$PARA_SRC_TRAIN.tok
PARA_TGT_TRAIN_TOK=$PARA_TGT_TRAIN.tok
PARA_SRC_VALID_TOK=$PARA_SRC_VALID.tok
PARA_TGT_VALID_TOK=$PARA_TGT_VALID.tok
PARA_SRC_TEST_TOK=$PARA_SRC_TEST.tok
PARA_TGT_TEST_TOK=$PARA_TGT_TEST.tok

# BPE / vocab files
BPE_CODES=$PROC_PATH/codes
SRC_VOCAB=$PROC_PATH/vocab.$SRC
TGT_VOCAB=$PROC_PATH/vocab.$TGT
FULL_VOCAB=$PROC_PATH/vocab.$SRC-$TGT

# train / valid / test monolingual BPE data
SRC_ALL_BPE=$PROC_PATH/all.$SRC
TGT_ALL_BPE=$PROC_PATH/all.$TGT
SRC_TRAIN_BPE=$PROC_PATH/train.$SRC
TGT_TRAIN_BPE=$PROC_PATH/train.$TGT
SRC_VALID_BPE=$PROC_PATH/valid.$SRC
TGT_VALID_BPE=$PROC_PATH/valid.$TGT
SRC_TEST_BPE=$PROC_PATH/test.$SRC
TGT_TEST_BPE=$PROC_PATH/test.$TGT

echo "monolingual BPE data..."
echo $SRC_ALL_BPE
echo $TGT_ALL_BPE
echo $SRC_TRAIN_BPE
echo $TGT_TRAIN_BPE
echo $SRC_VALID_BPE
echo $TGT_VALID_BPE
echo $SRC_TEST_BPE
echo $TGT_TEST_BPE

# valid / test parallel BPE data
PARA_SRC_TRAIN_BPE=$PROC_PATH/train.$SRC-$TGT.$SRC
PARA_TGT_TRAIN_BPE=$PROC_PATH/train.$SRC-$TGT.$TGT
PARA_SRC_VALID_BPE=$PROC_PATH/valid.$SRC-$TGT.$SRC
PARA_TGT_VALID_BPE=$PROC_PATH/valid.$SRC-$TGT.$TGT
PARA_SRC_TEST_BPE=$PROC_PATH/test.$SRC-$TGT.$SRC
PARA_TGT_TEST_BPE=$PROC_PATH/test.$SRC-$TGT.$TGT

echo "[====================================================]"
echo "[====================================================]"
echo "[====================================================]"

# tokenize data
if ! [[ -f "$ALL_SRC_ALL_TOK" && -f "$MONO_SRC_TRAIN_TOK" && -f "$MONO_SRC_VALID_TOK" && -f "$MONO_SRC_TEST_TOK" ]]; then
  echo "Tokenize $SRC monolingual data..."
  eval "cat $ALL_SRC_ALL    | $REPLACE_UNICODE_PUNCT | $NORM_PUNC | $REM_NON_PRINT_CHAR | python3 tools/lowercase_and_remove_accent.py | tools/tokenize.sh $SRC > $ALL_SRC_ALL_TOK"
  eval "cat $MONO_SRC_TRAIN | $REPLACE_UNICODE_PUNCT | $NORM_PUNC | $REM_NON_PRINT_CHAR | python3 tools/lowercase_and_remove_accent.py | tools/tokenize.sh $SRC > $MONO_SRC_TRAIN_TOK"
  eval "cat $MONO_SRC_VALID | $REPLACE_UNICODE_PUNCT | $NORM_PUNC | $REM_NON_PRINT_CHAR | python3 tools/lowercase_and_remove_accent.py | tools/tokenize.sh $SRC > $MONO_SRC_VALID_TOK"
  eval "cat $MONO_SRC_TEST  | $REPLACE_UNICODE_PUNCT | $NORM_PUNC | $REM_NON_PRINT_CHAR | python3 tools/lowercase_and_remove_accent.py | tools/tokenize.sh $SRC > $MONO_SRC_TEST_TOK"
fi
if ! [[ -f "$ALL_TGT_ALL_TOK" && -f "$MONO_TGT_TRAIN_TOK" && -f "$MONO_TGT_VALID_TOK" && -f "$MONO_TGT_TEST_TOK" ]]; then
  echo "Tokenize $TGT monolingual data..."
  eval "cat $ALL_TGT_ALL    | $REPLACE_UNICODE_PUNCT | $NORM_PUNC | $REM_NON_PRINT_CHAR | python3 tools/lowercase_and_remove_accent.py | tools/tokenize.sh $TGT > $ALL_TGT_ALL_TOK"
  eval "cat $MONO_TGT_TRAIN | $REPLACE_UNICODE_PUNCT | $NORM_PUNC | $REM_NON_PRINT_CHAR | python3 tools/lowercase_and_remove_accent.py | tools/tokenize.sh $TGT > $MONO_TGT_TRAIN_TOK"
  eval "cat $MONO_TGT_VALID | $REPLACE_UNICODE_PUNCT | $NORM_PUNC | $REM_NON_PRINT_CHAR | python3 tools/lowercase_and_remove_accent.py | tools/tokenize.sh $TGT > $MONO_TGT_VALID_TOK"
  eval "cat $MONO_TGT_TEST  | $REPLACE_UNICODE_PUNCT | $NORM_PUNC | $REM_NON_PRINT_CHAR | python3 tools/lowercase_and_remove_accent.py | tools/tokenize.sh $TGT > $MONO_TGT_TEST_TOK"
fi
echo "$SRC monolingual data tokenized in: $ALL_SRC_ALL_TOK, $MONO_SRC_TRAIN_TOK, $MONO_SRC_VALID_TOK, $MONO_SRC_TEST_TOK"
echo "$TGT monolingual data tokenized in: $ALL_TGT_ALL_TOK, $MONO_TGT_TRAIN_TOK, $MONO_TGT_VALID_TOK, $MONO_TGT_TEST_TOK"
echo "[====================================================]"
echo "[====================================================]"

# learn BPE codes
if [ ! -f "$BPE_CODES" ]; then
  echo "Learning BPE codes..."
  $FASTBPE learnbpe $CODES $ALL_SRC_ALL_TOK $ALL_TGT_ALL_TOK > $BPE_CODES
fi
echo "BPE learned in $BPE_CODES"
echo "[====================================================]"
echo "[====================================================]"

# apply BPE codes
if ! [[ -f "$SRC_ALL_BPE" ]]; then
  echo "Applying $SRC BPE codes..."
  $FASTBPE applybpe $SRC_ALL_BPE   $ALL_SRC_ALL_TOK    $BPE_CODES
  $FASTBPE applybpe $SRC_TRAIN_BPE $MONO_SRC_TRAIN_TOK $BPE_CODES
  $FASTBPE applybpe $SRC_VALID_BPE $MONO_SRC_VALID_TOK $BPE_CODES
  $FASTBPE applybpe $SRC_TEST_BPE  $MONO_SRC_TEST_TOK  $BPE_CODES
fi
if ! [[ -f "$TGT_ALL_BPE" ]]; then
  echo "Applying $TGT BPE codes..."
  $FASTBPE applybpe $TGT_ALL_BPE   $ALL_TGT_ALL_TOK    $BPE_CODES
  $FASTBPE applybpe $TGT_TRAIN_BPE $MONO_TGT_TRAIN_TOK $BPE_CODES
  $FASTBPE applybpe $TGT_VALID_BPE $MONO_TGT_VALID_TOK $BPE_CODES
  $FASTBPE applybpe $TGT_TEST_BPE  $MONO_TGT_TEST_TOK  $BPE_CODES
fi
echo "BPE codes applied to $SRC in: $SRC_ALL_BPE, $SRC_ALL_BPE, $SRC_TRAIN_BPE, $SRC_VALID_BPE, $SRC_TEST_BPE"
echo "BPE codes applied to $TGT in: $TGT_ALL_BPE, $TGT_ALL_BPE, $TGT_TRAIN_BPE, $TGT_VALID_BPE, $TGT_TEST_BPE"
echo "[====================================================]"
echo "[====================================================]"

# extract source and target vocabulary
if ! [[ -f "$SRC_VOCAB" && -f "$TGT_VOCAB" ]]; then
  echo "Extracting vocabulary..."
  $FASTBPE getvocab $SRC_ALL_BPE > $SRC_VOCAB
  $FASTBPE getvocab $TGT_ALL_BPE > $TGT_VOCAB
fi
echo "$SRC vocab in: $SRC_VOCAB"
echo "$TGT vocab in: $TGT_VOCAB"

# extract full vocabulary
if ! [[ -f "$FULL_VOCAB" ]]; then
  echo "Extracting vocabulary..."
  $FASTBPE getvocab $SRC_TRAIN_BPE $TGT_TRAIN_BPE > $FULL_VOCAB
fi
echo "Full vocab in: $FULL_VOCAB"
echo "[====================================================]"
echo "[====================================================]"

# binarize data
echo "Binarizing $SRC data..."
python3 $MAIN_PATH/preprocess.py $FULL_VOCAB $SRC_TRAIN_BPE
python3 $MAIN_PATH/preprocess.py $FULL_VOCAB $SRC_VALID_BPE
python3 $MAIN_PATH/preprocess.py $FULL_VOCAB $SRC_TEST_BPE

echo "Binarizing $TGT data..."
python3 $MAIN_PATH/preprocess.py $FULL_VOCAB $TGT_TRAIN_BPE
python3 $MAIN_PATH/preprocess.py $FULL_VOCAB $TGT_VALID_BPE
python3 $MAIN_PATH/preprocess.py $FULL_VOCAB $TGT_TEST_BPE
echo "$SRC binarized data in: $SRC_TRAIN_BPE.pth, $SRC_VALID_BPE.pth, $SRC_TEST_BPE.pth"
echo "$TGT binarized data in: $TGT_TRAIN_BPE.pth, $TGT_VALID_BPE.pth, $TGT_TEST_BPE.pth"


echo "[====================================================]"
echo "[====================================================]"
echo "[====================================================]"


### PARALLEL DATA

echo "Tokenizing valid and test data..."
eval "cat $PARA_SRC_TRAIN | $REPLACE_UNICODE_PUNCT | $NORM_PUNC | $REM_NON_PRINT_CHAR | python3 tools/lowercase_and_remove_accent.py | tools/tokenize.sh $SRC > $PARA_SRC_TRAIN_TOK"
eval "cat $PARA_TGT_TRAIN | $REPLACE_UNICODE_PUNCT | $NORM_PUNC | $REM_NON_PRINT_CHAR | python3 tools/lowercase_and_remove_accent.py | tools/tokenize.sh $TGT > $PARA_TGT_TRAIN_TOK"
eval "cat $PARA_SRC_VALID | $REPLACE_UNICODE_PUNCT | $NORM_PUNC | $REM_NON_PRINT_CHAR | python3 tools/lowercase_and_remove_accent.py | tools/tokenize.sh $SRC > $PARA_SRC_VALID_TOK"
eval "cat $PARA_TGT_VALID | $REPLACE_UNICODE_PUNCT | $NORM_PUNC | $REM_NON_PRINT_CHAR | python3 tools/lowercase_and_remove_accent.py | tools/tokenize.sh $TGT > $PARA_TGT_VALID_TOK"
eval "cat $PARA_SRC_TEST  | $REPLACE_UNICODE_PUNCT | $NORM_PUNC | $REM_NON_PRINT_CHAR | python3 tools/lowercase_and_remove_accent.py | tools/tokenize.sh $SRC > $PARA_SRC_TEST_TOK"
eval "cat $PARA_TGT_TEST  | $REPLACE_UNICODE_PUNCT | $NORM_PUNC | $REM_NON_PRINT_CHAR | python3 tools/lowercase_and_remove_accent.py | tools/tokenize.sh $TGT > $PARA_TGT_TEST_TOK"
echo "[====================================================]"
echo "[====================================================]"

echo "Applying BPE to valid and test files..."
$FASTBPE applybpe $PARA_SRC_TRAIN_BPE $PARA_SRC_TRAIN_TOK $BPE_CODES $SRC_VOCAB
$FASTBPE applybpe $PARA_TGT_TRAIN_BPE $PARA_TGT_TRAIN_TOK $BPE_CODES $TGT_VOCAB
$FASTBPE applybpe $PARA_SRC_VALID_BPE $PARA_SRC_VALID_TOK $BPE_CODES $SRC_VOCAB
$FASTBPE applybpe $PARA_TGT_VALID_BPE $PARA_TGT_VALID_TOK $BPE_CODES $TGT_VOCAB
$FASTBPE applybpe $PARA_SRC_TEST_BPE  $PARA_SRC_TEST_TOK  $BPE_CODES $SRC_VOCAB
$FASTBPE applybpe $PARA_TGT_TEST_BPE  $PARA_TGT_TEST_TOK  $BPE_CODES $TGT_VOCAB
echo "[====================================================]"
echo "[====================================================]"

echo "Binarizing data..."
rm -f $PARA_SRC_TRAIN_BPE.pth $PARA_TGT_TRAIN_BPE.pth $PARA_SRC_VALID_BPE.pth $PARA_TGT_VALID_BPE.pth $PARA_SRC_TEST_BPE.pth $PARA_TGT_TEST_BPE.pth
python3 $MAIN_PATH/preprocess.py $FULL_VOCAB $PARA_SRC_TRAIN_BPE
python3 $MAIN_PATH/preprocess.py $FULL_VOCAB $PARA_TGT_TRAIN_BPE
python3 $MAIN_PATH/preprocess.py $FULL_VOCAB $PARA_SRC_VALID_BPE
python3 $MAIN_PATH/preprocess.py $FULL_VOCAB $PARA_TGT_VALID_BPE
python3 $MAIN_PATH/preprocess.py $FULL_VOCAB $PARA_SRC_TEST_BPE
python3 $MAIN_PATH/preprocess.py $FULL_VOCAB $PARA_TGT_TEST_BPE


echo "[====================================================]"
echo "[====================================================]"
echo "[====================================================]"

#
# Link monolingual validation and test data to parallel data
#
#ln -sf $PARA_SRC_VALID_BPE.pth $SRC_VALID_BPE.pth
#ln -sf $PARA_TGT_VALID_BPE.pth $TGT_VALID_BPE.pth
#ln -sf $PARA_SRC_TEST_BPE.pth  $SRC_TEST_BPE.pth
#ln -sf $PARA_TGT_TEST_BPE.pth  $TGT_TEST_BPE.pth

#
# Summary
#
echo ""
echo "===== Data summary"
echo "Monolingual training data:"
echo "    $SRC: $SRC_TRAIN_BPE.pth"
echo "    $TGT: $TGT_TRAIN_BPE.pth"
echo "Monolingual validation data:"
echo "    $SRC: $SRC_VALID_BPE.pth"
echo "    $TGT: $TGT_VALID_BPE.pth"
echo "Monolingual test data:"
echo "    $SRC: $SRC_TEST_BPE.pth"
echo "    $TGT: $TGT_TEST_BPE.pth"
echo "Parallel training data:"
echo "    $SRC: $PARA_SRC_TRAIN_BPE.pth"
echo "    $TGT: $PARA_TGT_TRAIN_BPE.pth"
echo "Parallel validation data:"
echo "    $SRC: $PARA_SRC_VALID_BPE.pth"
echo "    $TGT: $PARA_TGT_VALID_BPE.pth"
echo "Parallel test data:"
echo "    $SRC: $PARA_SRC_TEST_BPE.pth"
echo "    $TGT: $PARA_TGT_TEST_BPE.pth"
echo ""
