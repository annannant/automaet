*** Settings ***
Library           Selenium2Library
Library           HttpLibrary.HTTP
Library           Collections
Library           OperatingSystem
Library           String
Library           DateTime

Test Teardown    Close All Browsers

*** Test Cases ***
TRUE_KMS After Sale Load Content
    [Tags]      test_link
    Log To Console   test

