<!-- start upload block-->
<script type="text/javascript">
<!--
{literal}
function addItemsToParent() {
	var itemsIds = new Array() ;
	$(":checkbox").each(function() {
		try {
			if(this.checked && this.name == 'chk_bedita_item') { itemsIds[itemsIds.length] = $(this).attr("value") ;}
		} catch(e) {
		}
	}) ;
	for(i=0;i<itemsIds.length;i++) {
		$("#tr_"+itemsIds[i]).remove();
	}

	{/literal}{$relation}CommitUploadById(itemsIds, '{$relation}'){literal};
}

function loadMultimediaAssoc(urlSearch) {
	$("#fragment-3").load(urlSearch, function() {
		$("#loading").hide();
		$("#searchMultimediaShowAll").show();
	});
}

$(document).ready(function(){
	$(".selItems").bind("click", function(){
		var check = $("input:checkbox",$(this).parent().parent()).get(0).checked ;
		$("input:checkbox",$(this).parent().parent()).get(0).checked = !check ;
	}) ;
	/* select/unselect each item's checkbox */
	$(".selectAll").bind("click", function(e) {
		var status = this.checked;
		$(".itemCheck").each(function() { this.checked = status; });
	}) ;
	/* select/unselect main checkbox if all item's checkboxes are checked */
	$(".itemCheck").bind("click", function(e) {
		var status = true;
		$(".itemCheck").each(function() { if (!this.checked) return status = false;});
		$(".selectAll").each(function() { this.checked = status;});
	}) ;
	
	$("#searchMultimedia").bind("click", function() {
		var textToSearch = $(this).prev().val();
		$("#loading").show();
		loadMultimediaAssoc("{/literal}{$html->url("/streams/searchStreams")}/{$object_id|default:'0'}/{$collection|default:'0'}/{literal}" + textToSearch);
	});
	$("#searchMultimediaText").focus(function() {
		$(this).val("");
	});
	$("#searchMultimediaShowAll").click(function() {
		$("#loading").show();
		loadMultimediaAssoc("{/literal}{$html->url("/streams/showStreams")}/{$object_id|default:'0'}/{$collection|default:'0'}/{literal}");
	});
});
//-->
{/literal}
</script>

<div id="formMultimediaAssoc">
	<fieldset>
		<div>
			<input type="text" id="searchMultimediaText" name="searchMultimediaItems" value="{$streamSearched|default:'search'}"/>
			<input id="searchMultimedia" type="button" value="{t}Search{/t}"/>
			<input type="button" id="searchMultimediaShowAll" value="{t}Show all{/t}" style="display: none;" />
		</div>
		{if !empty($items)}
			<p>{t}Total number of{/t} {t}{$itemType} items{/t}: {$beToolbar->size()}</p>
			<table class="indexList" style="clear: left;">
			<tr>
				<th><input type="checkbox" class="selectAll" id="selectAll"/><label for="selectAll"> {t}(Un)Select All{/t}</label></th>
				<th>{$beToolbar->order('id', 'id')}</th>
				{*
				<th>{$beToolbar->order('title', 'Title')}</th>
				<th>{$beToolbar->order('status', 'Status')}</th>
				<th>{$beToolbar->order('created', 'Created')}</th>
				<th>{t}Type{/t}</th>
				*}
				<th>{t}Thumb{/t}</th>
				<th>{t}Title{/t}</th>
				<th>{t}File name{/t}</th>
				{*<th>{t}MIME type{/t}</th>*}
				<th>{t}File size{/t}</th>
				<th>{$beToolbar->order('lang', 'Language')}</th>
			</tr>
	
			{foreach from=$items item='mobj' key='mkey'}
			<tr class="rowList" id="tr_{$mobj.id}">
				<td><input type="checkbox" value="{$mobj.id}" name="chk_bedita_item" class="itemCheck"/></td>
				<td><a class="selItems" href="javascript:void(0);">{$mobj.id}</a></td>
				{*
				<td>{$mobj.title}</td>
				<td>{$mobj.status}</td>
				<td>{$mobj.created|date_format:'%b %e, %Y'}</td>
				<td>{$mobj.bedita_type|default:""}</td>
				*}
				<td>
				{assign var="thumbWidth" 		value = 30}
				{assign var="thumbHeight" 		value = 30}
				{assign var="filePath"			value = $mobj.path}
				{assign var="mediaPath"         value = $conf->mediaRoot}
				{assign_concat var="mediaCacheBaseURL"	0=$conf->mediaUrl  1="/" 2=$conf->imgCache 3="/"}
				{assign_concat var="mediaCachePATH"		0=$conf->mediaRoot 1=$conf->DS 2=$conf->imgCache 3=$conf->DS}
	
				{if strtolower($mobj.ObjectType.name) == "image"}
					{thumb 
						width			= $thumbWidth
						height			= $thumbHeight
						file			= $mediaPath$filePath
						cache			= $mediaCacheBaseURL
						cachePATH		= $mediaCachePATH
					}
				{elseif ($mobj.provider|default:false)}
					{assign_associative var="attributes" style="width:30px;heigth:30px;"}
					<div><a href="{$filePath}" target="_blank">{$mediaProvider->thumbnail($mobj, $attributes) }</a></div>
				{else}
					<div><a href="{$conf->mediaUrl}{$filePath}" target="_blank"><img src="{$session->webroot}img/mime/{$mobj.type}.gif" /></a></div>
				{/if}
				</td>
				<td>{$mobj.title|default:""}</td>
				<td>{$mobj.name|default:""}</td>
				{*<td>{$mobj.type|default:""}</td>*}
				<td>{$mobj.size|default:""}</td>
				<td>{$mobj.lang}</td>
			</tr>
			{/foreach}
	
			<tr>
				<td colspan="10">
					<input type="button" onclick="javascript:addItemsToParent();" value=" (+) {t}Add selected items{/t}"/>
				</td>
			</tr>
			</table>

		{else}
			{t}No {$itemType} item found{/t}
		{/if}
	</fieldset>
	
</div>
<!-- end upload block -->