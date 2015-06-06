fetch2hdfs_file () {
    URL=$1
    HDFS_PATH=$2
    EXTRACT=$3
    CWD=`pwd`
    TSTAMP=`date +%s`
    FOLDER=/tmp/fetch2hdfs_$TSTAMP
    rm -rf $FOLDER
    mkdir $FOLDER
    cd $FOLDER
    curl -O -J -L "$URL"
    FILE=`ls`

    if [ ! "$FILE" ] ; then
        echo "Can't fetch $URL"
        cd $CWD
        rm -rf $FOLDER
        return
    fi

    if [ $EXTRACT = 1 ] ; then
        case "$FILE" in
            *.tar.bz2)   tar xvjf "$FILE"; rm -f "$FILE"   ;;
            *.tar.xz)    tar xvJf "$FILE"; rm -f "$FILE"   ;;
            *.tar.gz)    tar xvzf "$FILE"; rm -f "$FILE"   ;;
            *.bz2)       bunzip2 "$FILE"; rm -f "$FILE"    ;;
            *.rar)       rar x "$FILE"; rm -f "$FILE"      ;;
            *.gz)        gunzip "$FILE"; rm -f "$FILE"     ;;
            *.tar)       tar xvf "$FILE"; rm -f "$FILE"    ;;
            *.tbz2)      tar xvjf "$FILE"; rm -f "$FILE"   ;;
            *.tgz)       tar xvzf "$FILE"; rm -f "$FILE"   ;;
            *.zip)       unzip "$FILE"; rm -f "$FILE"      ;;
            *.Z)         uncompress "$FILE"; rm -f "$FILE" ;;
            *.7z)        7za x "$FILE"; rm -f "$FILE"      ;;
            *.a)         ar x "$FILE"; rm -f "$FILE"       ;;
        esac
    fi

    if ! hdfs dfs -test -d $HDFS_PATH ; then
        hdfs dfs -mkdir -p $HDFS_PATH
    fi

    hdfs dfs -put * $HDFS_PATH
    cd $CWD
    rm -rf $FOLDER
}

FIRST_ARG=$1
shift

if [ $FIRST_ARG = "-x" ] ; then
    EXTRACT=1
    HDFS_PATH=$1
    shift
else
    EXTRACT=0
    HDFS_PATH=$FIRST_ARG
fi

(($#)) || echo "Usage: $0 [-x] <hdfs_path> <urls>"

for i; do
    fetch2hdfs_file $i $HDFS_PATH $EXTRACT
done
