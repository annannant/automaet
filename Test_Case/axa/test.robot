*** Settings ***
Library           Selenium2Library
Library           HttpLibrary.HTTP
Library           Collections
Library           OperatingSystem
Library           String
Library           DateTime
Resource          ${CURDIR}/../../Resource/init.robot
Resource          ${CURDIR}/keywords/keywords.robot

Test Teardown    Close All Browsers

*** Test Cases ***
AXA
    [Tags]      test_link
    Log To Console   test


