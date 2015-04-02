<script type="text/javascript">
    $(document).ready(function(){
		openAtStart("#data-source, #data-options");

		$('.import-type input[type=radio]').click(function() {
			$('.import-file input[type=file]').prop( "disabled", false );

			var htmlOptions = '{t}Selected filter has no options{/t}.';
			var importOptions;
			// TODO
			if(importOptions) {
				options = '';
			}
			$('#data-options').html(htmlOptions);
		});
		/* drag&drop disabled, file upload should be managed in controller for preview
		var myDropzone = new Dropzone(".import .mainhalf", {
			url: "/home/importLoadFile"}
		);
		*/
    });
</script>

{$view->element('modulesmenu')}

{include file="inc/menuleft.tpl"}

{include file="inc/menucommands.tpl"}


<div class="head">
	<h1>{t}Import data{/t}</h1>
</div>

<div class="mainfull import">
<form action="{$html->url('/home/importData')}" method="post" name="importData" enctype="multipart/form-data">
{$beForm->csrf()}

	<div class="mainhalf">

		<div class="tab stayopen"><h2>{t}Source data{/t}</h2></div>
		<fieldset id="data-source">
			<div class="import-type">
				Import data type:
				<ul>
					{foreach $filters as $filter => $filterData}
					<li>
						<input name="data[type]" type="radio" value="{$filter}" id="select-{$filter}" />
						<label for="select-{$filter}">{$filterData.label}</label> &nbsp;
					</li>
					{/foreach}
				</ul>
			</div>

			<hr>

			<div class="import-file">
				{t}Select file{/t}:
				<input type="file" name="Filedata" disabled />
			</div>

			<div class="import-button-container">
				<input type="submit" value="load" />
			</div>
		</fieldset>

	</div>


	<div class="mainhalf">
		<div class="tab stayopen"><h2>{t}Import options{/t}</h2></div>

		<fieldset id="data-options">
			<p>Seleziona un filtro di  importazione nei Dati sorgente.</p>
		</fieldset>

		{foreach $filters as $filter => $filterData}
			<div id="filterOptions-{$filter}">
				{foreach $filterData.options as $filterOption}
				<p>
					<label>{$filterOption.label|default:$filter}</label>
					{if $filterOption.dataType == 'boolean'}
						<input type="checkbox" {if !empty($filterOption.defaultValue) && $filterOption.defaultValue}checked="checked"{/if} />
					{elseif $filterOption.dataType == 'number'}
						<input type="text" {if !empty($filterOption.defaultValue)}value="{$filterOption.defaultValue}"{/if} />
					{elseif $filterOption.dataType == 'text'}
						<input type="text" {if !empty($filterOption.defaultValue)}value="{$filterOption.defaultValue}"{/if} />
					{elseif $filterOption.dataType == 'options'}
						{if !empty($filterOption.multipleChoice) && $filterOption.multipleChoice}
							{foreach $filterOption.values as $optionVal => $optionLabel}
								<input type="checkbox" {if !empty($filterOption.defaultValue) && ($filterOption.defaultValue == $optionVal )}checked="checked"{/if} /> {$optionLabel}
							{/foreach}
						{else}
							<select>
							{foreach $filterOption.values as $optionVal => $optionLabel}
								<option value="{$optionVal}" {if !empty($filterOption.defaultValue) && ($filterOption.defaultValue == $optionVal )}selected="selected"{/if}>{$optionLabel}</option>
							{/foreach}
							</select>
						{/if}
					{/if}
				</p>
				{/foreach}
				{*
				{$filterOption.defaultValue}
				{$filterOption.mandatory}
				{$filterOption.multipleChoice}
				*}
			</div>
		{/foreach}

		{* SAMPLE OPTIONS <!--
			<select id="areaSectionAssoc" class="areaSectionAssociation" name="data[destination]">
				<option>--</option>
				<option>Selezione della sezione dell'albero in cui importare</option>
				{$beTree->option($tree)}
			</select>
			<hr />
			<input type="checkbox" checked="true" /> include media
			<hr/>
			{t}Status{/t}: {html_radios name="data[status]" options=$conf->statusOptions selected=$object.status|default:$conf->defaultStatus separator="&nbsp;"}
			
			<div id="finalimport" style="display:none; padding:10px 0px 10px 0px; margin:10px 0px 10px 0px; border-top:1px solid gray">
				<input type="submit" style="padding:10px" value="start import" />
			</div>
		--> *}
	</div>
</form>
</div>

