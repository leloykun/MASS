SRC=$1
TGT=$2

echo $SRC
echo $TGT

UNSUP_PATH=$3 #data
SUP_PATH=$4   #../MASS-supNMT/data

cp $UNSUP_PATH/processed/en-zh/train.$SRC $SUP_PATH/mono/train.$SRC
cp $UNSUP_PATH/processed/en-zh/valid.$SRC $SUP_PATH/mono/valid.$SRC
cp $UNSUP_PATH/processed/en-zh/test.$SRC  $SUP_PATH/mono/test.$SRC

cp $UNSUP_PATH/processed/en-zh/train.$TGT $SUP_PATH/mono/train.$TGT
cp $UNSUP_PATH/processed/en-zh/valid.$TGT $SUP_PATH/mono/valid.$TGT
cp $UNSUP_PATH/processed/en-zh/test.$TGT  $SUP_PATH/mono/test.$TGT

cp $UNSUP_PATH/processed/en-zh/train.$SRC-$TGT.$SRC $SUP_PATH/para/train.$SRC
cp $UNSUP_PATH/processed/en-zh/valid.$SRC-$TGT.$SRC $SUP_PATH/para/valid.$SRC
cp $UNSUP_PATH/processed/en-zh/test.$SRC-$TGT.$SRC  $SUP_PATH/para/test.$SRC

cp $UNSUP_PATH/processed/en-zh/train.$SRC-$TGT.$TGT $SUP_PATH/para/train.$TGT
cp $UNSUP_PATH/processed/en-zh/valid.$SRC-$TGT.$TGT $SUP_PATH/para/valid.$TGT
cp $UNSUP_PATH/processed/en-zh/test.$SRC-$TGT.$TGT  $SUP_PATH/para/test.$TGT

cp $UNSUP_PATH/processed/en-zh/vocab.$SRC  $SUP_PATH/mono/vocab.$SRC
cp $UNSUP_PATH/processed/en-zh/vocab.$TGT  $SUP_PATH/mono/vocab.$TGT
cp $UNSUP_PATH/processed/en-zh/vocab.$SRC  $SUP_PATH/para/vocab.$SRC
cp $UNSUP_PATH/processed/en-zh/vocab.$TGT  $SUP_PATH/para/vocab.$TGT

#cp $UNSUP_PATH/mono/train.$SRC.tok $SUP_PATH/mono/train.$SRC
#cp $UNSUP_PATH/mono/valid.$SRC.tok $SUP_PATH/mono/valid.$SRC
#cp $UNSUP_PATH/mono/test.$SRC.tok  $SUP_PATH/mono/test.$SRC

#cp $UNSUP_PATH/mono/train.$TGT.tok $SUP_PATH/mono/train.$TGT
#cp $UNSUP_PATH/mono/valid.$TGT.tok $SUP_PATH/mono/valid.$TGT
#cp $UNSUP_PATH/mono/test.$TGT.tok  $SUP_PATH/mono/test.$TGT

#cp $UNSUP_PATH/para/train.$SRC.tok $SUP_PATH/para/train.$SRC
#cp $UNSUP_PATH/para/valid.$SRC.tok $SUP_PATH/para/valid.$SRC
#cp $UNSUP_PATH/para/test.$SRC.tok  $SUP_PATH/para/test.$SRC

#cp $UNSUP_PATH/para/train.$TGT.tok $SUP_PATH/para/train.$TGT
#cp $UNSUP_PATH/para/valid.$TGT.tok $SUP_PATH/para/valid.$TGT
#cp $UNSUP_PATH/para/test.$TGT.tok  $SUP_PATH/para/test.$TGT

#cp $UNSUP_PATH/processed/en-zh/vocab.$SRC  $SUP_PATH/mono/vocab.$SRC
#cp $UNSUP_PATH/processed/en-zh/vocab.$TGT  $SUP_PATH/mono/vocab.$TGT
#cp $UNSUP_PATH/processed/en-zh/vocab.$SRC  $SUP_PATH/para/vocab.$SRC
#cp $UNSUP_PATH/processed/en-zh/vocab.$TGT  $SUP_PATH/para/vocab.$TGT
