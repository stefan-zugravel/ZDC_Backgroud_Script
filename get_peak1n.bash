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
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNA_TC_A/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do0peak1n.bash
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNA_SUM_A/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do1peak1n.bash
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNC_TC_A/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do2peak1n.bash
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNC_SUM_A/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do3peak1n.bash
else
    curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNA_TC_A/?Accept=application/json' | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do0peak1n.bash
    curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNA_SUM_A/?Accept=application/json' | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do1peak1n.bash
    curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNC_TC_A/?Accept=application/json' | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do2peak1n.bash
    curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNC_SUM_A/?Accept=application/json' | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do3peak1n.bash
fi

bash GetPlots/do0peak1n.bash > /dev/null 2>&1
bash GetPlots/do1peak1n.bash > /dev/null 2>&1
bash GetPlots/do2peak1n.bash > /dev/null 2>&1
bash GetPlots/do3peak1n.bash > /dev/null 2>&1

if [ "$STR" == "SPECIFIC" ]; then
    irun2=$(curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNA_TC_A/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0].RunNumber')
else
    irun2=$(curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNA_TC_A/?Accept=application/json' | jq -r '.objects[0].RunNumber')
fi

rm -rf "results/$irun2/1n"
mkdir "results/$irun2"    > /dev/null 2>&1
mkdir "results/$irun2/1n" > /dev/null 2>&1

root -q "get_peak1n.C($irun2)"