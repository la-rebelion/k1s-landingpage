# K1s Landingpage
K1s is the 1st Kubernetes Serverless Cluster Simulator, and this is the landing page repo

---

## How to run the container in Kubernetes?

Based on the docker-compose file:

```yaml
#docker-compose-k8s.yaml
version: "3.9"
services:
  k1s-lp:
    container_name: k1s-lp
    image: adrianescutia/landingpage
    restart: unless-stopped
    env_file: $PWD/.env
    volumes:
      # Getting error if mounting this folder, had to create as mounted volumes
      - app_public:/usr/local/apache2/htdocs/
    ports:
      - "3000:80"

volumes:
  app_public:
    driver: local
    driver_opts:
      type: none
      device: $PWD/public-html
      o: bind
```

**Remember to rename the `dotenv` example to `.env` and set the values (optional), file has some dummy values.**

If you need to override the `.env` file:

`docker compose --env-file ~/.env-landingpage --project-name k1s-landingpage up -d`

Default `.env`:

`docker compose --project-name k1s-lp up -d`

## Deploy in Kubernetes instead?

1. [Install kompose](https://kubernetes.io/docs/tasks/configure-pod-container/translate-compose-kubernetes/).
2. In the directory where your `docker-compose.yaml` is, run:  
    `kompose convert`

Apply the generated file, describe the service and check the `NodePort` port.

```bash
kubectl apply -f k1s-lp-service.yaml
```

### Util commands

```bash
kubectl describe service k1s-lp | grep NodePort | awk '{print $3}' | cut -d'/' -f1 | xargs -I {} echo "http://localhost:{}"
# get the cluster IP with kubectl cluster-info
kubectl cluster-info | grep 'control plane' | awk '/http/ {print $NF}' | sed 's/\x1b\[[0-9;]*m//g'
# get the pod labels
kubectl get pods --show-labels
# get the deployment name from the k1s-lp-service.yaml
kubectl get pods -l io.kompose.service=k1s-lp -o jsonpath="{.items[0].metadata.name}"
```

Copy the landing page `index.html` and the `.env` to the cluster:

```bash
./copy_files.sh your-namespace your-deployment
```

References: 

* https://docs.docker.com/compose/environment-variables/set-environment-variables/#cli
* https://kubernetes.io/docs/tasks/configure-pod-container/translate-compose-kubernetes/
* https://docs.docker.com/compose/reference/envvars/
  