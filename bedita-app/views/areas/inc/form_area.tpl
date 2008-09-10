{assign var=object_lang value=$object.lang|default:$conf->defaultLang}

<fieldset id="properties">	

	
	<input type="hidden" name="data[id]" value="{$object.id|default:''}"/>
	<input type="hidden" name="data[title]" value="{$object.title|default:''}"/>
	

	<table style="width:100%">
		<tr>
			<th>{t}Title{/t}:</th>
			<td>
				<input class="{literal}{required:true,minLength:1}{/literal}" title="{t}Title is required{/t}"	type="text" name="data[title]"	value="{$object.title|default:''|escape:'html'|escape:'quotes'}" />
			</td>
		</tr>

		<tr>
			<th>{t}Main language{/t}:</th>
			<td>
				<select name="data[lang]" id="main_lang">
				{foreach key=val item=label from=$conf->langOptions name=langfe}
					<option {if $val==$object_lang}selected="selected"{/if} value="{$val}">{$label}</option>
				{/foreach}
				</select>
			</td>
		</tr>
		<tr>
			<th>{t}Public name{/t}:</th>
			<td>
				<input type="text" name="data[public_name]" value="{$object.public_name|default:''|escape:'html'|escape:'quotes'}""/>
			</td>
			
		</tr>
		<tr>
			<th>{t}Description{/t}:</th>
			<td>
				<textarea class="autogrowarea" name="data[description]">{$object.description|default:''|escape:'html'|escape:'quotes'}</textarea>
			</td>
		</tr>
	<tr>
		<th>{t}Nickname{/t}:</th>
		<td>
			<input disabled type="text" name="data[nickname]" value="{$object.nickname|default:''|escape:'html'|escape:'quotes'}"/>
		</td>
		
	</tr>
	<tr>
		<th>{t}status{/t}:</th>
		<td>
			{html_radios name="data[status]" options=$conf->statusOptions selected=$object.status|default:$conf->status separator=" "}
		</td>
		
	</tr>

	<tr>
		<th>{t}Public url{/t}:</th>
		<td>
			<input type="text" name="data[public_url]" value="{$object.public_url|default:''}""/>
		</td>
	</tr>
	
	<tr>
		<th>{t}Staging url{/t}:</th>
		<td>
			<input type="text" name="data[staging_url]" value="{$object.staging_url|default:''}""/>
		</td>
	</tr>
	
	<tr>
		<th>{t}Contact email{/t}:</th>
		<td>
			<input type="text" name="data[email]" value="{$object.email|default:''|escape:'html'|escape:'quotes'}"
			class="{literal}{email:true}{/literal}" title="{t}Use a valid email{/t}"/>
		</td>
		
	</tr>
	<tr>
		<th>{t}Creator{/t}:</th>
		<td>
			<input type="text" name="data[creator]" value="{$object.creator|default:''|escape:'html'|escape:'quotes'}"
			class="{literal}{required:true,minLength:1}{/literal}" title="{t 1='1'}Creator is required (at least %1 alphanumerical char){/t}"/>
		</td>
		
	</tr>
	<tr>
		<th>{t}Publisher{/t}:</th>
		<td>
			<input type="text" name="data[publisher]" value="{$object.publisher|default:''|escape:'html'|escape:'quotes'}"
			class="{literal}{required:true,minLength:1}{/literal}" title="{t 1='1'}Publisher is required (at least %1 alphanumerical char){/t}"/>
		</td>
		
	</tr>
	<tr>
		<th>{t}Rights{/t}:</th>
		<td>
			<input type="text" name="data[rights]" value="{$object.rights|default:''|escape:'html'|escape:'quotes'}"
			class="{literal}{required:true,minLength:1}{/literal}" title="{t 1='1'}Rights is required (at least %1 alphanumerical char){/t}"/>
		</td>
		
	</tr>
	<tr>
		<th>{t}License{/t}:</th>
		<td>
			<input type="text" name="data[license]" value="{$object.license|default:''|escape:'html'|escape:'quotes'}"
			class="{literal}{required:true,minLength:1}{/literal}" title="{t 1='1'}License is required (at least %1 alphanumerical char){/t}"/>
		</td>
		
	</tr>
	</table>

</fieldset>

	
{include file="../common_inc/form_custom_properties.tpl" el=$object|default:null}
{include file="../common_inc/form_permissions.tpl" el=$object|default:null recursion=true}


	
	

</form>
