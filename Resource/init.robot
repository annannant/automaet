*** Settings ***
Resource          ${CURDIR}/Config/${ENV}/env.robot
Resource          ${CURDIR}/Config/users.robot

*** Variables ***
${ENV}                staging
${BROWSER}            Chrome
${SELENIUM_SPEED}     2
${TIMEOUT}            10s
