*** Settings ***
Library           Selenium2Library
Library           HttpLibrary.HTTP
Library           Collections
Library           OperatingSystem
Library           String
Library           DateTime
Library           BuiltIn

Resource          ${CURDIR}/../../Resource/init.robot
Resource          ${CURDIR}/keywords/keywords.robot
Resource          ${CURDIR}/keywords/login.robot

#Test Teardown    Close All Browsers

*** Variables ***


*** Test Cases ***
AXA TC_1 Customer Create Link Success
    [Tags]      TC_1
    Login as Customer
    Customer - Display Add Link Button
    Customer - Input and submit form

AXA TC_2 Marketing Create Link Success
    [Tags]      TC_2
    Login as Marketing
    Marketing - Display Add Link Button
    Marketing - Input and submit form








