# ML DevOps Assignment

Three tasks, one repository.

| Task | What | Where |
|---|---|---|
| 1. Record all commands | Three RandomForest experiments with configs, metrics and git history | `experiments/`, `docs/experiment_record.pdf` |
| 2. CI/CD workflow | GitHub Actions pipeline: lint, test, train-and-gate, build, deploy | `.github/workflows/ci.yml`, `docs/cicd_workflow_report.pdf` |
| 3. Jenkins deployment | Declarative pipeline with triggers, post-build actions and deploy/rollback script | `Jenkinsfile`, `deploy.sh`, `docs/jenkins_deployment_report.pdf` |

## Run locally
```bash
pip install scikit-learn pyyaml
./ci.sh                                   # runs lint, test, quality gate, build, deploy
python experiments/train.py experiments/exp3_deeper.yaml
```
