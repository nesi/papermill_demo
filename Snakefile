kernel = "papermill_demo"
runs = ["short", "long"]


rule all:
    input:
        expand("results_wf/model_fitting_{run}.ipynb", run=runs)


rule preprocessing:
    input:
        notebook="notebooks/preprocessing.ipynb"
    output:
        notebook="results_wf/preprocessing.ipynb",
        dataset="results_wf/dataset.npz"
    shell:
        "papermill -k {kernel} -p result_file {output.dataset} "
        "{input.notebook} {output.notebook} "
        

rule model_fitting:
    input:
        notebook="notebooks/model_fitting.ipynb",
        runconfig="config/{run}_run.yaml",
        dataset="results_wf/dataset.npz"
    output:
        notebook="results_wf/model_fitting_{run}.ipynb"
    threads:
        lambda wildcards: 20 if wildcards.run == "long" else 1
    shell:
        "papermill -k {kernel} -p input_file {input.dataset} -f {input.runconfig} "
        "-p n_jobs {threads} {input.notebook} {output.notebook}"
