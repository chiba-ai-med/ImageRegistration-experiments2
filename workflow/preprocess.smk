import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("8.10.0")

container: 'docker://koki/ir-experiments:20241001'

rule all:
    input:
        'data/source/all_exp.csv',
        'data/target/all_exp.csv',
        'data/source/sum_exp.csv',
        'data/target/sum_exp.csv',
        'data/source/bin_sum_exp.csv',
        'data/target/bin_sum_exp.csv',
        'data/source/celltype.csv',
        'data/target/celltype.csv',
        'data/source/x.csv',
        'data/target/x.csv',
        'data/source/y.csv',
        'data/target/y.csv'

rule preprocess_csv:
    output:
        'data/source/all_exp.csv',
        'data/target/all_exp.csv',
        'data/source/sum_exp.csv',
        'data/target/sum_exp.csv',
        'data/source/bin_sum_exp.csv',
        'data/target/bin_sum_exp.csv',
        'data/source/celltype.csv',
        'data/target/celltype.csv',
        'data/source/x.csv',
        'data/target/x.csv',
        'data/source/y.csv',
        'data/target/y.csv'
    resources:
        mem_mb=10000000
    benchmark:
        'benchmarks/preprocess_csv.txt'
    log:
        'logs/preprocess_csv.log'
    shell:
        'src/preprocess_csv.sh {output} >& {log}'