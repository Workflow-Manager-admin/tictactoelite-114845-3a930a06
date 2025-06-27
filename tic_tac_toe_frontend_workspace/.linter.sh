#!/bin/bash
cd /home/kavia/workspace/code-generation/tictactoelite-114845-3a930a06/tic_tac_toe_frontend_workspace/tic_tac_toe_frontend
npx eslint 
$ESLINT_EXIT_CODE
npm run build
BUILD_EXIT_CODE=$?
if [ $ESLINT_EXIT_CODE -ne 0 ] || [ $BUILD_EXIT_CODE -ne 0 ]; then
   exit 1
fi

