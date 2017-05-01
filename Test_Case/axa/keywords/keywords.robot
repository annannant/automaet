*** Settings ***
Library           Selenium2Library
Library           HttpLibrary.HTTP
Library           Collections
Library           OperatingSystem
Library           String
Library           DateTime

*** Variables ***
${PERIOD_1}     Monthly
${PERIOD_2}     3 Month
${PERIOD_3}     Yearly

${PAYMENT_TYPE_1}     เบี้ยงวดแรก (01)
${PAYMENT_TYPE_2}     เบี้ยงวดต่ออายุ (02)
${PAYMENT_TYPE_3}     คืนเงินกู้อัตโนมัติ - APL (05)


*** Keywords ***
Customer - Display Add Link Button
    Wait Until Element Is Visible    jquery=#add_link_customer       ${TIMEOUT}
    Click Element                    jquery=#add_link_customer
    Wait Until Element Is Not Visible           jquery=#add_link_marketing

Customer - Input and submit form
    Set Data Link
    Wait Until Element Is Visible    jquery=#firstname       ${TIMEOUT}
    Input Text          jquery=#firstname               ${Link_FirstName}
    Input Text          jquery=#lastname                ${Link_LastName}
    Input Text          jquery=#policy_number           ${Link_PolicyNumber}
    Input Text          jquery=#idcard                  ${Link_IDCard}
    Input Text          jquery=#amount                  ${Link_Amount}
    Click Element       //*[@value='${Link_PaymentType}']
    Click Element       jquery=#create_link
    Confirm Create Link

Marketing - Display Add Link Button
    Wait Until Element Is Visible    jquery=#add_link_marketing       ${TIMEOUT}
    Click Element                    jquery=#add_link_marketing
    Wait Until Element Is Not Visible           jquery=#add_link_customer

Marketing - Input and submit form
    Set Data Link
    Wait Until Element Is Visible    jquery=#firstname       ${TIMEOUT}
    Input Text          jquery=#firstname               ${Link_FirstName}
    Input Text          jquery=#lastname                ${Link_LastName}
    Input Text          jquery=#policy_number           ${Link_PolicyNumber}
    Input Text          jquery=#policy_name             ${Link_PolicyName}
    Input Text          jquery=#idcard                  ${Link_IDCard}
    Input Text          jquery=#amount                  ${Link_Amount}
    Input Text          jquery=#agent_firstname         ${Link_AgentFirstName}
    Input Text          jquery=#agent_lastname          ${Link_AgentLastName}
    Input Text          jquery=#agent_code         ${Link_AgentCode}
	Wait Until Element Is Visible   jquery=#payment_period   60s
	Select From List    jquery=#payment_period    ${Link_PaymentPeriod}
    Click Element       jquery=#create_link
    Confirm Create Link

Confirm Create Link
    Sleep               5s
    Wait Until Element Is Visible    //*[@class='sa-confirm-button-container']/button[@class='confirm']       ${TIMEOUT}
    Click Element                    //*[@class='sa-confirm-button-container']/button[@class='confirm']

Set Data Link
    ${amount}=	        Evaluate	    random.randint(100, 5000)	modules=random
    ${ran}=	            Evaluate	    random.randint(10, 999)	modules=random
    ${ran_pay}=	        Evaluate	    random.randint(1, 3)	modules=random
    ${ran_period}=	    Evaluate	    random.randint(1, 3)	modules=random
    ${ran_idcard}=	    Evaluate	    random.randint(10, 99)	modules=random
    Log To Console      ran_idcard=${ran_idcard}
    ${hex}=	            Generate Random String	4	abcdefghijklmnop
    Set Test Variable       ${Link_FirstName}           Customer${hex}
    Set Test Variable       ${Link_LastName}            Lastname${hex}
    Set Test Variable       ${Link_PolicyNumber}        P00${ran}
    Set Test Variable       ${Link_PolicyName}          Policy Name ${ran}
    Set Test Variable       ${Link_IDCard}              11111111111${ran_idcard}
    Set Test Variable       ${Link_Amount}              ${amount}
    Set Test Variable       ${Link_PaymentType}         ${PAYMENT_TYPE_${ran_pay}}
    Set Test Variable       ${Link_PaymentPeriod}         ${PERIOD_${ran_pay}}
    Set Test Variable       ${Link_AgentFirstName}      Agentf${hex}
    Set Test Variable       ${Link_AgentLastName}       Agentl${hex}
    Set Test Variable       ${Link_AgentCode}           AGENT${ran}
