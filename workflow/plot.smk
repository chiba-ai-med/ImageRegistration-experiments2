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
        # Datasets
        'plot/dataset/FINISH',
        # OT
        expand('plot/gw1/{gw1p}/FINISH',
            gw1p=GW1_PARAMETERS),
        expand('plot/gw2/{gw2p}/FINISH',
            gw2p=GW2_PARAMETERS),
        expand('plot/merged_gw/{merged_gwp}/FINISH',
            merged_gwp=MERGED_GW_PARAMETERS),
        expand('plot/qgw/{qgwp}/FINISH',
            qgwp=QGW_PARAMETERS),
        expand('plot/merged_qgw/{merged_qgwp}/FINISH',
            merged_qgwp=MERGED_QGW_PARAMETERS),
        # Guided PLS
        'plot/guidedpls/FINISH',
        'plot/guidedpls/pairplot_batch.png',
        'plot/guidedpls/pairplot_anatomy.png',
        'plot/guidedpls/pairplot_anatomy_legend.png',
        # Evaluation Mesures
        'plot/cc.png'

# Datasets
rule plot_datasets:
    input:
        'data/source/all_exp.csv',
        'data/target/all_exp.csv',
        'data/source/exp.csv',
        'data/target/exp.csv',
        'data/source/anatomy.csv',
        'data/target/anatomy.csv',
        'data/source/x.csv',
        'data/target/x.csv',
        'data/source/y.csv',
        'data/target/y.csv'
    output:
        'plot/dataset/FINISH'
    container:
        'docker://koki/ir-experiments-r:20250701'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_datasets.txt'
    log:
        'logs/plot_datasets.log'
    shell:
        'src/plot_datasets.sh {input} {output} >& {log}'

# OT
rule plot_gw1:
    input:
        'output/gw1/{gw1p}/warped.txt',
        'data/target/x.csv',
        'data/target/y.csv'
    output:
        'plot/gw1/{gw1p}/FINISH'
    container:
        'docker://koki/ir-experiments-r:20250701'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_gw1_{gw1p}.txt'
    log:
        'logs/plot_gw1_{gw1p}.log'
    shell:
        'src/plot_ot.sh {input} {output} >& {log}'

rule plot_gw2:
    input:
        'output/gw2/{gw2p}/warped.txt',
        'data/target/x.csv',
        'data/target/y.csv'
    output:
        'plot/gw2/{gw2p}/FINISH'
    container:
        'docker://koki/ir-experiments-r:20250701'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_gw2_{gw2p}.txt'
    log:
        'logs/plot_gw2_{gw2p}.log'
    shell:
        'src/plot_ot.sh {input} {output} >& {log}'

rule plot_merged_gw:
    input:
        'output/merged_gw/{merged_gwp}/warped.txt',
        'data/target/x.csv',
        'data/target/y.csv'
    output:
        'plot/merged_gw/{merged_gwp}/FINISH'
    container:
        'docker://koki/ir-experiments-r:20250701'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_merged_gw_{merged_gwp}.txt'
    log:
        'logs/plot_merged_gw_{merged_gwp}.log'
    shell:
        'src/plot_ot.sh {input} {output} >& {log}'

rule plot_qgw:
    input:
        'output/qgw/{qgwp}/warped.txt',
        'data/target/x.csv',
        'data/target/y.csv'
    output:
        'plot/qgw/{qgwp}/FINISH'
    container:
        'docker://koki/ir-experiments-r:20250701'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_qgw_{qgwp}.txt'
    log:
        'logs/plot_qgw_{qgwp}.log'
    shell:
        'src/plot_ot.sh {input} {output} >& {log}'

rule plot_merged_qgw:
    input:
        'output/merged_qgw/{merged_qgwp}/warped.txt',
        'data/target/x.csv',
        'data/target/y.csv'
    output:
        'plot/merged_qgw/{merged_qgwp}/FINISH'
    container:
        'docker://koki/ir-experiments-r:20250701'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_merged_qgw_{merged_qgwp}.txt'
    log:
        'logs/plot_merged_qgw_{merged_qgwp}.log'
    shell:
        'src/plot_ot.sh {input} {output} >& {log}'

# Guided PLS
rule plot_guidedpls:
    input:
        'output/guidedpls/warped.txt',
        'data/target/x.csv',
        'data/target/y.csv'
    output:
        'plot/guidedpls/FINISH'
    container:
        'docker://koki/ir-experiments-r:20250701'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_guidedpls.txt'
    log:
        'logs/plot_guidedpls.log'
    shell:
        'src/plot_ot.sh {input} {output} >& {log}'

rule plot_pairs_guidedpls:
    input:
        'output/guidedpls/guidedpls.RData',
        'data/source/anatomy.csv',
        'data/target/anatomy.csv'
    output:
        'plot/guidedpls/pairplot_batch.png',
        'plot/guidedpls/pairplot_anatomy.png',
        'plot/guidedpls/pairplot_anatomy_legend.png'
    container:
        'docker://koki/ir-experiments-r:20250701'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_guidedpls.txt'
    log:
        'logs/plot_guidedpls.log'
    shell:
        'src/plot_pairs.sh {input} {output} >& {log}'

# CC
rule plot_cc:
    output:
        'plot/cc.png'
    container:
        'docker://koki/ir-experiments-r:20250701'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_cc.txt'
    log:
        'logs/plot_cc.log'
    shell:
        'src/plot_cc.sh {output} >& {log}'
