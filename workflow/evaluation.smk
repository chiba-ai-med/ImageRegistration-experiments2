import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("8.10.0")

GW1_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']
GW2_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']
MERGED_GW_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']
QGW_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']
MERGED_QGW_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']

rule all:
    input:
        # Optimal Transport
        expand("output/gw1/{gw1p}/cc.csv",
            gw1p=GW1_PARAMETERS),
        expand("output/gw2/{gw2p}/cc.csv",
            gw2p=GW2_PARAMETERS),
        expand("output/merged_gw/{merged_gwp}/cc.csv",
            merged_gwp=MERGED_GW_PARAMETERS),
        expand("output/qgw/{qgwp}/cc.csv",
            qgwp=QGW_PARAMETERS),
        expand("output/merged_qgw/{merged_qgwp}/cc.csv",
            merged_qgwp=MERGED_QGW_PARAMETERS),
        # Guided PLS
        "output/guidedpls/cc.csv"

rule evaluate_gw1:
    input:
        "output/gw1/{gw1p}/warped.txt",
        "data/target/all_exp.csv"
    output:
        "output/gw1/{gw1p}/cc.csv"
    container:
        'docker://koki/ir-experiments-r:20250701'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/evaluate_gw1_{gw1p}.txt'
    log:
        'logs/evaluate_gw1_{gw1p}.log'
    shell:
        'src/evaluate.sh {input} {output} >& {log}'

rule evaluate_gw2:
    input:
        "output/gw2/{gw2p}/warped.txt",
        "data/target/all_exp.csv"
    output:
        "output/gw2/{gw2p}/cc.csv"
    container:
        'docker://koki/ir-experiments-r:20250701'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/evaluate_gw2_{gw2p}.txt'
    log:
        'logs/evaluate_gw2_{gw2p}.log'
    shell:
        'src/evaluate.sh {input} {output} >& {log}'

rule evaluate_merged_gw:
    input:
        "output/merged_gw/{merged_gwp}/warped.txt",
        "data/target/all_exp.csv"
    output:
        "output/merged_gw/{merged_gwp}/cc.csv"
    container:
        'docker://koki/ir-experiments-r:20250701'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/evaluate_merged_gw_{merged_gwp}.txt'
    log:
        'logs/evaluate_merged_gw_{merged_gwp}.log'
    shell:
        'src/evaluate.sh {input} {output} >& {log}'

rule evaluate_qgw:
    input:
        "output/qgw/{qgwp}/warped.txt",
        "data/target/all_exp.csv"
    output:
        "output/qgw/{qgwp}/cc.csv"
    container:
        'docker://koki/ir-experiments-r:20250701'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/evaluate_qgw_{qgwp}.txt'
    log:
        'logs/evaluate_qgw_{qgwp}.log'
    shell:
        'src/evaluate.sh {input} {output} >& {log}'

rule evaluate_merged_qgw:
    input:
        "output/merged_qgw/{merged_qgwp}/warped.txt",
        "data/target/all_exp.csv"
    output:
        "output/merged_qgw/{merged_qgwp}/cc.csv"
    container:
        'docker://koki/ir-experiments-r:20250701'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/evaluate_merged_qgw_{merged_qgwp}.txt'
    log:
        'logs/evaluate_merged_qgw_{merged_qgwp}.log'
    shell:
        'src/evaluate.sh {input} {output} >& {log}'

rule evaluate_guidedpls:
    input:
        "output/guidedpls/warped.txt",
        "data/target/all_exp.csv"
    output:
        "output/guidedpls/cc.csv"
    container:
        'docker://koki/ir-experiments-r:20250701'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/evaluate_guidedpls.txt'
    log:
        'logs/evaluate_guidedpls.log'
    shell:
        'src/evaluate.sh {input} {output} >& {log}'
