<?php
/*-----8<--------------------------------------------------------------------
 * 
 * BEdita - a semantic content management framework
 * 
 * Copyright 2008 ChannelWeb Srl, Chialab Srl
 * 
 * This file is part of BEdita: you can redistribute it and/or modify
 * it under the terms of the Affero GNU General Public License as published 
 * by the Free Software Foundation, either version 3 of the License, or 
 * (at your option) any later version.
 * BEdita is distributed WITHOUT ANY WARRANTY; without even the implied 
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the Affero GNU General Public License for more details.
 * You should have received a copy of the Affero GNU General Public License 
 * version 3 along with BEdita (see LICENSE.AGPL).
 * If not, see <http://gnu.org/licenses/agpl-3.0.html>.
 * 
 *------------------------------------------------------------------->8-----
 */

App::import('Core', 'String');
App::import('Core', 'Controller');
App::import('Controller', 'App'); // BeditaException

/**
 * 
 * @link			http://www.bedita.com
 * @version		$Revision$
 * @modifiedby 		$LastChangedBy$
 * @lastmodified	$LastChangedDate$
 * 
 * $Id$
 */

class GettextShell extends Shell {

	// smarty open tag
	protected $ldq;
	protected $rdq;
	protected $cmd;
	
	// extensions of smarty files
	protected $extensions = array('tpl');

	protected $poResult = array();
	
	public function __construct($dispatch) {
		$this->ldq = preg_quote('{');
		$this->rdq = preg_quote('}');
		$this->cmd = preg_quote('t');
		parent::__construct($dispatch);		
	}
	
	// "fix" string - strip slashes, escape and convert new lines to \n
	private function fs($str)
	{
		$str = stripslashes($str);
		$str = str_replace('"', '\"', $str);
		$str = str_replace("\n", '\n', $str);
		return $str;
	}

	// rips gettext strings from $file and prints them in C format
	private function parseFile($file)
	{
		$content = @file_get_contents($file);
	
		if (empty($content)) {
			return;
		}
	
		$matches = array();
		$rgxp = "/{$this->ldq}\s*({$this->cmd})\s*([^{$this->rdq}]*){$this->rdq}([^{$this->ldq}]*){$this->ldq}\/\\1{$this->rdq}/";
		preg_match_all($rgxp, $content, $matches);
		
		for ($i=0; $i < count($matches[0]); $i++) {
			// TODO: handle plural forms, file lines...!!!
//			if (preg_match('/plural\s*=\s*["\']?\s*(.[^\"\']*)\s*["\']?/', $matches[2][$i], $match)) {
//				$this->out('ngettext("'.$this->fs($matches[3][$i]).'","'.$this->fs($match[1]).'",x);'."\n");
//			} else {
//				$this->out('gettext("'.$this->fs($matches[3][$i]).'");'."\n");
//			}
			$item = $this->fs($matches[3][$i]);
			if(!in_array($item, $this->poResult)) {
				$this->poResult[] = $item;
			}
		}
	}

	// go through a directory
	private function parseDir($dir)
	{
		$folder = new Folder($dir);
        $tree = $folder->tree($dir, false);
        foreach ($tree as $files) {
            foreach ($files as $file) {
                if (!is_dir($file)) {
                	$f = new File($file);
                	$info = $f->info();
                	if(isset($info['extension']) && in_array($info['extension'], $this->extensions))	{
                		$this->parseFile($file);
                	}
                }
            }
        }
	}

	public function update() {
		
		$conf = Configure::getInstance();
		$tplPath = VIEWS;
		$localePath = APP."locale".DS;
		if (isset($this->params['frontend'])) {
			$f = new Folder($this->params['frontend']);
    		$tplPath = $f->path.DS."views".DS;
    		$localePath = $f->path.DS."locale".DS;
		}
        $this->out('Creating master .po looking in: '.$tplPath);
		$this->parseDir($tplPath);    	
        // write .pot file
        $potFilename = $localePath."master.pot";
        $this->out("Writing new .pot file: $potFilename");
		$pot = new File($potFilename, true);
        $pot->write("msgid \"\"\nmsgstr \"\""
			. "\n\"POT-Creation-Date: ". date("Y-m-d H:i:s") . "\\n\""
        	. "\n\"MIME-Version: 1.0\"\n\"Content-Transfer-Encoding: 8bit\\n\""
			. "\n\"Language-Team: BEdita I18N & I10N Team\\n\""
			. "\n\"Project-Id-Version: BEdita 3\\n\""
			. "\n\"Plural-Forms: nplurals=2; plural=(n != 1);\\n\""
			. "\n\"Content-Type: text/plain; charset=utf-8\\n\"\n");
		sort($this->poResult);
		foreach ($this->poResult as $res) {
        	$pot->write("\n\nmsgid \"". $res ."\"");
        	$pot->write("\nmsgstr \"\"");
        }
		$pot->close();
		$this->hr();
		$this->out("Merging master.pot with current .po files");
		$this->hr();
		$folder = new Folder($localePath);
		$ls = $folder->ls();
		foreach ($ls[0] as $loc) {
			if($loc[0] != '.') { // only "regular" dirs...
	        	$poFile = $localePath. $loc . DS . "LC_MESSAGES" . DS . "default.po";
				$this->out("Merging $poFile");
				$mergeCmd = "msgmerge --backup=off -N -U " . $poFile . " " . $potFilename;
				exec($mergeCmd);
				$this->hr();
			}
		}
		$this->out('Done');
	}

	function help() {
		$this->out('Available functions:');
        $this->out('1. update [-frontend <frontend path>]: create master.pot and merge .po files');
  		$this->out(' ');
  		$this->out("    -frontend \t create frontend master.pot looking at <frontend path> [use frontend /app path]");
  		$this->out(' ');
	}
	
}

?>