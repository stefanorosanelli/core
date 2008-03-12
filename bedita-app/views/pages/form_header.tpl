{literal}
<script type="text/javascript">
$(document).ready(function(){
	$("#delBEObject").submitConfirm({
		{/literal}
		action: "{if !empty($delparam)}{$html->url($delparam)}{else}{$html->url('delete/')}{/if}",
		message: "{t}Are you sure that you want to delete the item?{/t}"
		{literal}
	});
});
</script>
{/literal}

<div class="FormPageHeader">
<h1>{t}{$object.title|default:"New Item"}{/t}</h1>
<fieldset>
<table border="0" cellspacing="0" cellpadding="0">
<tr>
	<td>
		<a id="openAllBlockLabel" style="display:block;" href="javascript:showAllBlockPage(1)"><span style="font-weight:bold;">&gt;</span> {t}open details{/t}</a>
		<a id="closeAllBlockLabel" href="javascript:hideAllBlockPage()"><span style="font-weight:bold;">&gt;</span> {t}close details{/t}</a>
	</td>
	{if $module_modify eq '1'}
	<td style="padding-left:40px;" nowrap>
		<input class="submit" type="submit" value=" {t}Save{/t} " name="save"/>	
		<input type="button" name="delete" id="delBEObject" class="submit" value="{t}Delete{/t}" {if !($object.id|default:false)}disabled="1"{/if}/>
	</td>
	{else}
	<td style="padding-left:40px;" nowrap>&#160;</td>
	{/if}
	<td style="padding-left:40px">&nbsp;</td>
</tr>
</table>
</fieldset>
</div>