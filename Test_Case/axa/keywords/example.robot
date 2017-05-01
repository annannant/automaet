*** Settings ***
Library           Selenium2Library
Library           HttpLibrary.HTTP
Library           Collections
Library           OperatingSystem
Library           String
Library           DateTime


*** Variables ***
${SERVICE_TOOLS_URL}             http://service.loc/true-kms/tools

${PROJECT_NAME}                  /true-kms
${LOCAL_KMS_CM_DIR}              ${PROJECT_NAME}/content/kms/CM
${LOCAL_KMS_LH_DIR}              ${PROJECT_NAME}/content/kms/lh
${LOCAL_ASSETS_DIR}              ${PROJECT_NAME}/public/assets

#assets
${CUSTOMIZATION_SEARCH}        http://truekms.true.th:80/customization
${CUSTOMIZATION_REPLACE}       ${LOCAL_ASSETS_DIR}/customization
${TEMPLATES_SEARCH}            http://truekms.true.th:80/templates
${TEMPLATES_REPLACE}           ${LOCAL_ASSETS_DIR}/templates

#content
${LH_SEARCH}                   http://truekms.true.th:80/kms/lh
${LH_REPLACE}                  ${LOCAL_KMS_LH_DIR}
${CM_SEARCH}                   http://truekms.true.th:80/kms/CM
${CM_REPLACE}                  ${LOCAL_KMS_CM_DIR}
${CM_TOPICS_SEARCH}            http://truekms.true.th:80/kms/CM/TOPICS
${CM_TOPICS_REPLACE}           ${LOCAL_KMS_CM_DIR}/TOPICS
${CM_LIST_SEARCH}              http://truekms.true.th:80/kms/CM/LIST
${CM_LIST_REPLACE}             ${LOCAL_KMS_CM_DIR}/LIST
${CM_SCENARIO_SEARCH}          http://truekms.true.th:80/kms/CM/SCENARIO
${CM_SCENARIO_REPLACE}         ${LOCAL_KMS_CM_DIR}/SCENARIO
${ARCHIVE_SEARCH}               http://truekms.true.th:80/archive
${ARCHIVE_REPLACE}              ${LOCAL_ASSETS_DIR}/archive

#div
${DIV_TOOL_EXPAND}              <button id="open-schema" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-icon-only" role="button" aria-disabled="false" title="Schematic Diagram" style="display: inline-block;"><span class="ui-button-icon-primary ui-icon ui-icon-arrow-4-diag"></span><span class="ui-button-text">Schematic Diagram</span></button>

#json data
${CM_KMS_LH_SEARCH}               /kms/lh
${CM_KMS_LH_REPLACE}              /true-kms/content/kms/lh

${CM_KMS_CM_SEARCH}               /kms/CM
${CM_KMS_CM_REPLACE}              /true-kms/content/kms/CM
${CM_TRUE_KMS_CM_SEARCH}          /true-kms/CM
${CM_TRUE_KMS_CM_REPLACE}         /true-kms/content/kms/CM

*** Keywords ***
Css Process
    ${count_css}            Get Matching Xpath Count                //*/link[@href]
    Log To Console              Total css : ${count_css}
    : FOR    ${INDEX}    IN RANGE    1    ${count_css}+1

    \    ${link}=                Get Element Attribute              //*/link[@href][${INDEX}]@href
    \    Go To                                  ${SERVICE_TOOLS_URL}/download_assets.php?file=${link}
    \    Sleep      2s
    \    Go To           ${CURRENT_PAGE}
    \    Log To Console          ${INDEX}. ${link}

JS Process
    ${count_script}            Get Matching Xpath Count                 //head/script[@src]
    Log To Console              Total script on head : ${count_script}
    : FOR    ${INDEX_SC}    IN RANGE    1    ${count_script}+1
    \    ${link}=                Get Element Attribute                  //head/script[@src][${INDEX_SC}]@src
    \    Go To                  ${SERVICE_TOOLS_URL}/download_assets.php?file=${link}
    \    Sleep      2s
    \    Go To           ${CURRENT_PAGE}
    \    Log To Console         ${INDEX_SC}. ${link}
    JS Process on Div

JS Process on Div
    ${count_script}            Get Matching Xpath Count                 //div/script[@src]
    Log To Console              Total script on div : ${count_script}
    : FOR    ${INDEX_SC}    IN RANGE    1    ${count_script}+1
    \    ${link}=                Get Element Attribute                  //div/script[@src][${INDEX_SC}]@src
    \    Go To                  ${SERVICE_TOOLS_URL}/download_assets.php?file=${link}
    \    Sleep      2s
    \    Go To           ${CURRENT_PAGE}
    \    Log To Console         ${INDEX_SC}. ${link}

Save Content
    [Arguments]                 ${link_content}
    Log To Console              ${link_content}
    ${data}=                    Get File Info              ${link_content}
    ${path}=                    Get From Dictionary        ${data}       path
    ${file_name}=               Get From Dictionary        ${data}       file_name
    Log To Console              content_path=${path}
    Log To Console              content_file_name=${file_name}
    ${body}=                    Get Source
    ${body}=                    Replace URL             ${body}
    Create File                 ${CURDIR}/${path}${file_name}       ${body}

Replace URL
    [Arguments]     ${body}
    ${body}=   Replace String Using Regexp   ${body}   ${CUSTOMIZATION_SEARCH}      ${CUSTOMIZATION_REPLACE}
    ${body}=   Replace String Using Regexp   ${body}   ${TEMPLATES_SEARCH}          ${TEMPLATES_REPLACE}
    ${body}=   Replace String Using Regexp   ${body}   ${LH_SEARCH}                 ${LH_REPLACE}
    ${body}=   Replace String Using Regexp   ${body}   ${CM_SEARCH}                 ${CM_REPLACE}
    ${body}=   Replace String Using Regexp   ${body}   ${ARCHIVE_SEARCH}        ${ARCHIVE_REPLACE}
    ${body}=   Replace String Using Regexp   ${body}   ${CM_TOPICS_SEARCH}          ${CM_TOPICS_REPLACE}
    ${body}=   Replace String Using Regexp   ${body}   ${CM_LIST_SEARCH}            ${CM_LIST_REPLACE}
    ${body}=   Replace String Using Regexp   ${body}   ${CM_SCENARIO_SEARCH}        ${CM_SCENARIO_REPLACE}
    ${body}=   Replace String Using Regexp   ${body}   &lt;     <
    ${body}=   Replace String Using Regexp   ${body}   &amp;    &
    ${body}=   Replace String Using Regexp   ${body}   &gt;     >
#    ${body}=   Replace String Using Regexp   ${body}   ${LH_SRC_SEARCH}          ${LH_SRC_REPLACE}
    ${body}=   Replace String Using Regexp   ${body}   ${DIV_TOOL_EXPAND}        ${EMPTY}

    [return]       ${body}

Get File Info
    [Arguments]                 ${link_content}
    Log To Console              url_to_get_path=${link_content}
    Create Http Context         service.loc    http
    HttpLibrary.HTTP.GET        /true-kms/tools/file_content.php?file=${link_content}

    ${resp_json}=               Get Response Body
    ${data}=                    Parse Json            ${resp_json}
    [return]                    ${data}

Get node data json
    ${current_ver}=             Get Text            //span[@id='versions-list']/a[contains(@class, 'current-version')]
    ${itemId}=                  Get Value           //input[@name='item_id']
    Go To                       http://truekms.true.th/kms/lh/scenario/node/get?itemId=${itemId}&version=${current_ver}&displayRoot=true
    ${body}=                    Get Text            //pre
    ${body}=   Replace String Using Regexp   ${body}   ${CM_KMS_CM_SEARCH}        ${CM_KMS_CM_REPLACE}
    ${body}=   Replace String Using Regexp   ${body}   ${CM_KMS_LH_SEARCH}        ${CM_KMS_LH_REPLACE}
    ${body}=   Replace String Using Regexp   ${body}   ${CM_TRUE_KMS_CM_SEARCH}        ${CM_TRUE_KMS_CM_REPLACE}
    ${body}=                    Convert To String               ${body}
    Create File                 ${CURDIR}/content/kms/lh/scenario/node/get/${itemId}.php       ${body}

Login
    Open Browser    http://truekms.true.th    chrome
    Wait Until Element Is Visible    jquery=#IDToken1
    Input Text    jquery=#IDToken1    Wisaru4
    Input Text    jquery=#IDToken2    Hero1234*
    Click Element    //*[@class='SignInBtn']

List Etc Content
    [Arguments]         ${L1}
    Append To List      ${L1}       http://truekms.true.th/kms/CM/T_MARKETING/VIEW?item_id=1095708
    Append To List      ${L1}       http://truekms.true.th/kms/CM/T_MARKETING/VIEW?item_id=1148350
    Append To List      ${L1}       http://truekms.true.th/kms/CM/T_MARKETING/VIEW?item_id=1124008
    Append To List      ${L1}       http://truekms.true.th/kms/CM/T_MARKETING/VIEW?item_id=1136515
    Append To List      ${L1}       http://truekms.true.th/kms/CM/T_MARKETING/VIEW?item_id=1124122
    Append To List      ${L1}       http://truekms.true.th/kms/CM/T_MARKETING/VIEW?item_id=1124008
    Append To List      ${L1}       http://truekms.true.th/kms/CM/T_MARKETING/VIEW?item_id=1124122
    Append To List      ${L1}       http://truekms.true.th/kms/CM/T_MARKETING/VIEW?item_id=1133963
    [Return]            ${L1}

Upload Image
    [Arguments]      ${link}
    Go To            ${SERVICE_TOOLS_URL}/upload_image.php?file=${link}


List Contents
    ${LIST_CONTENT}=             Create List
    Append To List               ${LIST_CONTENT}            http://truekms.true.th/kms/CM/T_MARKETING/VIEW?item_id=1095708
    Append To List               ${LIST_CONTENT}            http://truekms.true.th/kms/CM/GENERAL/VIEW?item_id=80705
    Append To List               ${LIST_CONTENT}            http://truekms.true.th/kms/CM/GENERAL/VIEW?item_id=26887
    Append To List               ${LIST_CONTENT}            http://truekms.true.th/kms/CM/GENERAL/VIEW?item_id=630199
    Append To List               ${LIST_CONTENT}            http://truekms.true.th/kms/CM/LIST/VIEW?item_id=534094
    Append To List               ${LIST_CONTENT}            http://truekms.true.th/kms/CM/LIST/VIEW?item_id=534095

    [Return]     ${LIST_CONTENT}

Load Content
    [Arguments]     ${KM_URL}
    #index page
    ${KM_URL}=              Convert To String    ${KM_URL}
    Go To                   ${KM_URL}
    Sleep                   10s
    Save Content            ${KM_URL}

     # child page
    ${count_topic}          Get Matching Xpath Count                //td/a
    Log To Console          ${count_topic}
    : FOR    ${topic_number}    IN RANGE    1    ${count_topic}+1
    \    Log To Console    ${topic_number}
    \    ${current_topic_url}=      Get Element Attribute          //table/tbody/tr[${topic_number}]/td/table/tbody/tr/td/a@href
    \    Click Element              //table/tbody/tr[${topic_number}]/td/table/tbody/tr/td/a
    \    Set Test Variable          ${CURRENT_PAGE}                ${current_topic_url}
    \    Sleep      10s
    \    Save Content               ${CURRENT_PAGE}
    \    Sleep      10s
    \    Go To                      ${KM_URL}


Load link in content
    [Arguments]         ${MAIN_URL}      ${elementid}
    ${count_link}=             Get Matching Xpath Count        //tr[@elementid][${elementid}]//li/a
    Log To Console             ${elementid}. total link=${count_link}

    : FOR    ${li}    IN RANGE    1    ${count_link}+1
    \    #find link each li
    \    ${link_url}=             Get Element Attribute        //tr[@elementid][${elementid}]//li[${li}]/a@href
    \    Log To Console           ${link_url}
    \    Load link in content item   ${link_url}        ${MAIN_URL}

    #count link by span
    ${count_link_span}=             Get Matching Xpath Count        //tr[@elementid][${elementid}]//span/a
    Log To Console             ${elementid}. total link=${count_link_span}

    : FOR    ${span}    IN RANGE    1    ${count_link_span}+1
    \    #find link each li
    \    ${link_url}=             Get Element Attribute        //tr[@elementid][${elementid}]//span[${span}]/a@href
    \    Log To Console           ${link_url}
    \    Load link in content item   ${link_url}        ${MAIN_URL}

    #count link by div
    ${count_link_div}=             Get Matching Xpath Count        //tr[@elementid][${elementid}]//div/a
    Log To Console             ${elementid}. total link=${count_link_div}

    : FOR    ${div}    IN RANGE    1    ${count_link_div}+1
    \    #find link each li
    \    ${link_url}=             Get Element Attribute        //tr[@elementid][${elementid}]//div[${div}]/a@href
    \    Log To Console           ${link_url}
    \    Load link in content item   ${link_url}        ${MAIN_URL}

Load link in content item
    [Arguments]     ${link_url}     ${MAIN_URL}
    Go To                    ${link_url}
    Sleep                    10s
    Save Content             ${link_url}
    Sleep                    5s
    ${has_json}=             Get Matching Xpath Count          //li[contains(@class, 'tree-node')]
    Run Keyword If           ${has_json} > 0           Get node data json
    Go To                    ${MAIN_URL}

