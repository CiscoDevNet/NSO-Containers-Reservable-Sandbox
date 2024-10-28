#!/bin/bash

# Add rest-api-explorer.tar.gz
if [ -f "/tmp/packages/rest-api-explorer.tar.gz" ]; then
    mv /tmp/packages/rest-api-explorer.tar.gz $NCS_DIR/packages/ 
    ln -s $NCS_DIR/packages/rest-api-explorer.tar.gz $NCS_RUN_DIR/packages/rest-api-explorer.tar.gz
else
    echo "/tmp/packages/rest-api-explorer.tar.gz does not exist."
fi

# Add example router package
mv /tmp/packages/router $NCS_DIR/packages/
make -C $NCS_DIR/packages/router/src clean all
ln -s $NCS_DIR/packages/router/ $NCS_RUN_DIR/packages/