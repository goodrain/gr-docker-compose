function compose::config_update() {
    YAML_FILE=/etc/goodrain/docker-compose3.yaml
    mkdir -pv `dirname $YAML_FILE`
    if [ ! -f "$YAML_FILE" ];then
        echo "version: '2.1'" > $YAML_FILE
    fi
    ./dc-yaml.py -f $YAML_FILE -u
}


compose::config_update <<EOF
services:
  artifactory:
    container_name: artifactory
EOF
