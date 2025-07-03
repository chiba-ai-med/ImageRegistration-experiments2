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
        # GW1
        expand('output/gw1/{gw1p}/plan.pkl',
            gw1p=GW1_PARAMETERS),
        expand('output/gw1/{gw1p}/warped.txt',
            gw1p=GW1_PARAMETERS),
        # GW2
        expand('output/gw2/{gw2p}/plan.pkl',
            gw2p=GW2_PARAMETERS),
        expand('output/gw2/{gw2p}/warped.txt',
            gw2p=GW2_PARAMETERS),
        # Merged GW
        expand('output/merged_gw/{merged_gwp}/plan.pkl',
            merged_gwp=MERGED_GW_PARAMETERS),
        expand('output/merged_gw/{merged_gwp}/warped.txt',
            merged_gwp=MERGED_GW_PARAMETERS),
        # qGW (Log)
        expand('output/qgw/{qgwp}/plan.pkl',
            qgwp=QGW_PARAMETERS),
        expand('output/qgw/{qgwp}/warped.txt',
            qgwp=QGW_PARAMETERS),
        # Merged qGW (Log)
        expand('output/merged_qgw/{merged_qgwp}/plan.pkl',
            merged_qgwp=MERGED_QGW_PARAMETERS),
        expand('output/merged_qgw/{merged_qgwp}/warped.txt',
            merged_qgwp=MERGED_QGW_PARAMETERS)

#############################################
# Gromov-Wasserstein
#############################################
rule gw1:
    input:
        'data/source/all_exp.csv',
        'data/target/all_exp.csv'
    output:
        'output/gw1/{gw1p}/plan.pkl',
        'output/gw1/{gw1p}/warped.txt'
    container:
        'docker://koki/ot-experiments:20240719'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/gw1_{gw1p}.txt'
    log:
        'logs/gw1_{gw1p}.log'
    shell:
        'src/gw1.sh {input} {output} {wildcards.gw1p} >& {log}'

rule gw2:
    input:
        'data/source/all_exp.csv',
        'data/source/x.csv',
        'data/target/x.csv',
        'data/source/y.csv',
        'data/target/y.csv'
    output:
        'output/gw2/{gw2p}/plan.pkl',
        'output/gw2/{gw2p}/warped.txt'
    container:
        'docker://koki/ot-experiments:20240719'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/gw2_{gw2p}.txt'
    log:
        'logs/gw2_{gw2p}.log'
    shell:
        'src/gw2.sh {input} {output} {wildcards.gw2p} >& {log}'

rule merged_gw:
    input:
        'data/source/all_exp.csv',
        'data/target/all_exp.csv',
        'data/source/x.csv',
        'data/target/x.csv',
        'data/source/y.csv',
        'data/target/y.csv'
    output:
        'output/merged_gw/{merged_gwp}/plan.pkl',
        'output/merged_gw/{merged_gwp}/warped.txt'
    container:
        'docker://koki/ot-experiments:20240719'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/merged_gw_{merged_gwp}.txt'
    log:
        'logs/merged_gw_{merged_gwp}.log'
    shell:
        'src/merged_gw.sh {input} {output} {wildcards.merged_gwp} >& {log}'

#############################################
# Quantized Gromov-Wasserstein
#############################################
rule qgw:
    input:
        'data/source/all_exp.csv',
        'data/target/all_exp.csv'
    output:
        'output/qgw/{qgwp}/plan.pkl',
        'output/qgw/{qgwp}/warped.txt'
    container:
        'docker://koki/ot-experiments:20240719'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/qgw_{qgwp}.txt'
    log:
        'logs/qgw_{qgwp}.log'
    shell:
        'src/qgw.sh {input} {output} {wildcards.qgwp} >& {log}'

rule merged_qgw:
    input:
        'data/source/all_exp.csv',
        'data/target/all_exp.csv',
        'data/source/x.csv',
        'data/target/x.csv',
        'data/source/y.csv',
        'data/target/y.csv'
    output:
        'output/merged_qgw/{merged_qgwp}/plan.pkl',
        'output/merged_qgw/{merged_qgwp}/warped.txt'
    container:
        'docker://koki/ot-experiments:20240719'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/merged_qgw_{merged_qgwp}.txt'
    log:
        'logs/merged_qgw_{merged_qgwp}.log'
    shell:
        'src/merged_qgw.sh {input} {output} {wildcards.merged_qgwp} >& {log}'
