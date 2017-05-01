*** Settings ***
Library           Selenium2Library
Library           HttpLibrary.HTTP
Library           Collections
Library           OperatingSystem
Library           String
Library           DateTime
Resource          ${CURDIR}/../../Resource/init.robot
Resource          ${CURDIR}/keywords/keywords.robot
Resource          ${CURDIR}/keywords/login.robot

Test Teardown    Close All Browsers

*** Test Cases ***
AXA TC_01 Login success
    [Tags]      TC_01
    Login as Customer


