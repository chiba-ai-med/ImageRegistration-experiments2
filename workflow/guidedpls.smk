import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("8.10.0")

container: 'docker://koki/ir-experiments-r:20250701'

rule all:
	input:
		'output/guidedpls/warped.txt',
		'output/guidedpls/guidedpls.RData'

rule guidedpls:
	input:
		'data/source/all_exp.csv',
		'data/target/all_exp.csv',
		'data/source/anatomy.csv',
		'data/target/anatomy.csv'
	output:
		'output/guidedpls/warped.txt',
		'output/guidedpls/guidedpls.RData'
	resources:
		mem_mb=1000000
	benchmark:
		'benchmarks/guidedpls.txt'
	log:
		'logs/guidedpls.log'
	shell:
		'src/guidedpls.sh {input} {output} >& {log}'
