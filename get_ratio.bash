STR="LAST"
#STR="SPECIFIC"
irun=543995


rm -rf work/              > /dev/null 2>&1
rm -rf GetPlots/          > /dev/null 2>&1
mkdir results/            > /dev/null 2>&1
mkdir work/               > /dev/null 2>&1
mkdir GetPlots/           > /dev/null 2>&1


if [ "$STR" == "SPECIFIC" ]; then
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNA_TC_V/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do0.bash
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNA_SUM_V/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do1.bash
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNC_TC_V/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do2.bash
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNC_SUM_V/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do3.bash
else
    curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNA_TC_V/?Accept=application/json' | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do0.bash
    curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNA_SUM_V/?Accept=application/json' | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do1.bash
    curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNC_TC_V/?Accept=application/json' | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do2.bash
    curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNC_SUM_V/?Accept=application/json' | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do3.bash
fi


bash GetPlots/do0.bash > /dev/null 2>&1
bash GetPlots/do1.bash > /dev/null 2>&1
bash GetPlots/do2.bash > /dev/null 2>&1
bash GetPlots/do3.bash > /dev/null 2>&1


if [ "$STR" == "SPECIFIC" ]; then
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNA_SUM_V/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0].RunNumber'
    rm -rf "results/$(curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNC_SUM_V/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0].RunNumber')/ratio"
    mkdir "results/$(curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNC_SUM_V/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0].RunNumber')" > /dev/null 2>&1
    mkdir "results/$(curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNC_SUM_V/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0].RunNumber')/ratio" > /dev/null 2>&1
else
    curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNC_SUM_V/?Accept=application/json' | jq -r '.objects[0].RunNumber'
    rm -rf "results/$(curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNC_SUM_V/?Accept=application/json' | jq -r '.objects[0].RunNumber')/ratio"
    mkdir "results/$(curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNC_SUM_V/?Accept=application/json' | jq -r '.objects[0].RunNumber')" > /dev/null 2>&1
    mkdir "results/$(curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNC_SUM_V/?Accept=application/json' | jq -r '.objects[0].RunNumber')/ratio" > /dev/null 2>&1
fi


#curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNA_TC_V/RunNumber=545332?Accept=application/json' | jq -r '.objects[] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do0.bash
#curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNA_SUM_V/RunNumber=545332?Accept=application/json' | jq -r '.objects[] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do1.bash
#curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNC_TC_V/RunNumber=545332?Accept=application/json' | jq -r '.objects[] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do2.bash
#curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNC_SUM_V/RunNumber=545332?Accept=application/json' | jq -r '.objects[] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do3.bash
#curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNA_TC_V/?Accept=application/json' | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do0.bash
#curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNA_SUM_V/?Accept=application/json' | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do1.bash
#curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNC_TC_V/?Accept=application/json' | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do2.bash
#curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNC_SUM_V/?Accept=application/json' | jq -r '.objects[0] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do3.bash
#curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNA_SUM_V/RunNumber=545332?Accept=application/json' | jq -r '.objects[0].RunNumber'
#curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZNC_SUM_V/?Accept=application/json' | jq -r '.objects[0].RunNumber'