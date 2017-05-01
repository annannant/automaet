*** Settings ***
Library           Selenium2Library
Library           HttpLibrary.HTTP
Library           Collections
Library           OperatingSystem
Library           String
Library           DateTime

*** Variables ***

*** Keywords ***
Login
    [Arguments]     ${email}        ${password}
    Open Browser        ${AXA_URL}/admin/login          ${BROWSER}
    Wait Until Element Is Visible    jquery=#email      ${TIMEOUT}
    Wait Until Element Is Visible    jquery=#password       ${TIMEOUT}
    Input Text          jquery=#email         ${email}
    Input Text          jquery=#password      ${password}
    Click Element       //*[@id='SubmitLogin']

Login as Customer
    Login       ${CUSTOMER_EMAIL}     ${CUSTOMER_PASSWORD}

Login as Marketing
    Login       ${MARKETING_EMAIL}     ${MARKETING_PASSWORD}

Login as Guest
    Login       ${GUEST_EMAIL}     ${GUEST_PASSWORD}

