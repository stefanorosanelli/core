{*
** form form template
*}

<form action="{$html->url('/questionnaires/save')}" method="post" name="updateForm" id="updateForm" class="cmxform">
<input type="hidden" name="data[id]" value="{$object.id|default:''}"/>

	{include file="../common_inc/form_title_subtitle.tpl"}

	{include file="./inc/form_list_questions.tpl" object_type_id=$conf->objectTypes.questionnaire.id}

	{include file="../common_inc/form_properties.tpl" comments=false}
	
	{include file="../common_inc/form_categories.tpl"}
	
	{include file="../common_inc/form_tree.tpl"}
	
	{include file="../common_inc/form_assoc_objects.tpl" object_type_id=$conf->objectTypes.document.id}	
	
	{include file="../common_inc/form_tags.tpl"}
		
	{include file="../common_inc/form_translations.tpl"}

	{include file="../common_inc/form_advanced_properties.tpl" el=$object}
	
	{include file="../common_inc/form_custom_properties.tpl"}
	
	{include file="../common_inc/form_permissions.tpl" el=$object recursion=true}

</form>