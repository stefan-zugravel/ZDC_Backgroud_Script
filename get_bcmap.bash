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
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCTask/hbunch-ZNA_TC_TR_T0/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do0.bash
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCTask/hbunch-ZNA_SUM_T0/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do1.bash
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCTask/hbunch-ZNC_TC_TR_T0/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do2.bash
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCTask/hbunch-ZNC_SUM_T0/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do3.bash
else
    curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCTask/hbunch-ZNA_TC_TR_T0/?Accept=application/json' | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do0.bash
    curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCTask/hbunch-ZNA_SUM_T0/?Accept=application/json' | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do1.bash
    curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCTask/hbunch-ZNC_TC_TR_T0/?Accept=application/json' | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do2.bash
    curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCTask/hbunch-ZNC_SUM_T0/?Accept=application/json' | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do3.bash
fi

bash GetPlots/do0.bash > /dev/null 2>&1
bash GetPlots/do1.bash > /dev/null 2>&1
bash GetPlots/do2.bash > /dev/null 2>&1
bash GetPlots/do3.bash > /dev/null 2>&1

if [ "$STR" == "SPECIFIC" ]; then
    irun2=$(curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCTask/hbunch-ZNA_TC_TR_T0/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0].RunNumber')
else
    irun2=$(curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCTask/hbunch-ZNA_TC_TR_T0/?Accept=application/json' | jq -r '.objects[0].RunNumber')
fi

rm -rf "results/$irun2/BC"
mkdir "results/$irun2"       > /dev/null 2>&1
mkdir "results/$irun2/BC" > /dev/null 2>&1

root -q "get_bcmap.C($irun2)"