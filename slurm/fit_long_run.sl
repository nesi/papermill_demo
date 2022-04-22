#!/usr/bin/env bash
#SBATCH --time=00-00:10:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=4GB
#SBATCH --output logs/%j-%x.out
#SBATCH --error logs/%j-%x.out

# activate the conda environment
module purge && module load Miniconda3/4.10.3
source $(conda info --base)/etc/profile.d/conda.sh
conda activate ./venv

# run the model fitting notebook
papermill -k papermill_demo \
    -p input_file results/dataset.npz \
    -p n_jobs "$SLURM_CPUS_PER_TASK" \
    -f config/long_run.yaml \
    notebooks/model_fitting.ipynb \
    results/model_fitting_long.ipynb
