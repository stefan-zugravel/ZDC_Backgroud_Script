#STR="LAST"
STR="SPECIFIC"
irun=543437


rm -rf work/
rm -rf GetPlots/
mkdir work/
mkdir GetPlots/


if [ "$STR" == "SPECIFIC" ]; then
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZPA_TC_A/RunNumber=$irun?Accept=application/json" | jq -r '.objects[] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do0peak1p.bash
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZPA_SUM_A/RunNumber=$irun?Accept=application/json" | jq -r '.objects[] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do1peak1p.bash
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZPC_TC_A/RunNumber=$irun?Accept=application/json" | jq -r '.objects[] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"'  > GetPlots/do2peak1p.bash
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZPC_SUM_A/RunNumber=$irun?Accept=application/json" | jq -r '.objects[] | "curl http://ali-qcdb-gpn.cern.ch:8083\(.replicas[0]) -o work/\(.path|split("/")|join("_"))_\(.RunNumber).root"' > GetPlots/do3peak1p.bash
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
    curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZPA_TC_A/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0].RunNumber'
    rm -rf "$(curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZPA_TC_A/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0].RunNumber')"
    mkdir "$(curl -s "http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZPA_TC_A/RunNumber=$irun?Accept=application/json" | jq -r '.objects[0].RunNumber')"
else
    curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZPA_TC_A/?Accept=application/json' | jq -r '.objects[0].RunNumber'
    rm -rf "$(curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZPA_TC_A/?Accept=application/json' | jq -r '.objects[0].RunNumber')"
    mkdir "$(curl -s 'http://ali-qcdb-gpn.cern.ch:8083/browse/qc/ZDC/MO/QcZDCRecTask/h_TDC_ZPA_TC_A/?Accept=application/json' | jq -r '.objects[0].RunNumber')"
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