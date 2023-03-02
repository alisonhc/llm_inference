#!/usr/bin/env bash
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:A100:4
#SBATCH --mem=300GB
#SBATCH --time=04:00:00
#SBATCH --output=/data/tkew/projects/llm_ats/logs/%j.out

set -x

# defaults
BASE='/data/tkew/projects/llm_ats'

module purge
module load anaconda3 multigpu a100

eval "$(conda shell.bash hook)"
conda activate && echo "CONDA ENV: $CONDA_DEFAULT_ENV"
conda activate llm_hf1 && echo "CONDA ENV: $CONDA_DEFAULT_ENV"

cd "${BASE}" && echo $(pwd) || exit 1

python inference.py "$@"

# python inference.py \
#     --model_name_or_path "bigscience/bloom" \
#     --max_new_tokens 100 \
#     --max_memory 0.65 \
#     --batch_size 8 \
#     --num_beams 1 \
#     --num_return_sequences 1 \
#     --do_sample True \
#     --top_p 0.9 \
#     --examples "data/asset/dataset/valid.jsonl" \
#     --input_file "data/asset/dataset/asset.test.orig" \
#     --n_refs 1 \
#     --few_shot_n 3 \
#     --prompt_prefix "I want you to replace my complex sentence with simple sentence(s). Keep the meaning same, but make them simpler." \
#     --output_file "data/outputs/bloom/asset.test"