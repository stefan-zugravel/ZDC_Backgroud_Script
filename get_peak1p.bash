#STR="LAST"
#STR="SPECIFIC"
#irun=559147
if [ -z "$1" ]; then
    # No argument provided, set STR to "LAST"
    STR="LAST"
else
    # Argument provided, set STR to "SPECIFIC" and irun to the argument value
    STR="SPECIFIC"
    irun="$1"
fi

rm -rf work/              > /dev/null 2>&1
rm -rf GetPlots/          > /dev/null 2>&1
mkdir results/            > /dev/null 2>&1
mkdir work/               > /dev/null 2>&1
mkdir GetPlots/           > /dev/null 2>&1

if [ "$STR" == "SPECIFIC" ]; then
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZPA_TC_A/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do0peak1p.bash
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZPA_SUM_A/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do1peak1p.bash
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZPC_TC_A/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do2peak1p.bash
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZPC_SUM_A/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do3peak1p.bash
else
    curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZPA_TC_A/?Accept=application/json' | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do0peak1p.bash
    curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZPA_SUM_A/?Accept=application/json' | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do1peak1p.bash
    curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZPC_TC_A/?Accept=application/json' | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do2peak1p.bash
    curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZPC_SUM_A/?Accept=application/json' | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do3peak1p.bash
fi

bash GetPlots/do0peak1p.bash > /dev/null 2>&1
bash GetPlots/do1peak1p.bash > /dev/null 2>&1
bash GetPlots/do2peak1p.bash > /dev/null 2>&1
bash GetPlots/do3peak1p.bash > /dev/null 2>&1

if [ "$STR" == "SPECIFIC" ]; then
    irun2=$(curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZPA_TC_A/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0].RunNumber')
else
    irun2=$(curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZPA_TC_A/?Accept=application/json' | jq -r '.objects[0].RunNumber')
fi

rm -rf "results/$irun2/1p"
mkdir "results/$irun2"    > /dev/null 2>&1
mkdir "results/$irun2/1p" > /dev/null 2>&1

root -q "get_peak1p.C($irun2)"