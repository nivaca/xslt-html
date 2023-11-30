<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:tei="http://www.tei-c.org/ns/1.0"  
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:my="http://nicolasvaughan.org"
  exclude-result-prefixes="tei my xd xs"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  version="3.0">
  
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b>2020-06-01</xd:p>
      <xd:p><xd:b>Author:</xd:b>nivaca</xd:p>
      <xd:p>This file contains standard templates for generating
        xHTML from TEI.</xd:p>
    </xd:desc>
  </xd:doc>  
  
  
  <!-- -  -  -  -  -  -  IMPORTS  -  -  -  -  -  - --> 
  
  <!--<xd:doc>
    <xd:desc>
    <xd:p>contains x-ref related templates</xd:p>
    </xd:desc>
    </xd:doc>
  -->  
  <!--<xsl:import href="ref.xsl"/> -->
  
  
  
  <xd:doc>
    <xd:desc>
      <xd:p>contains citation related templates</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:import href="quote.xsl"/>
  
  <!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  - -->
  
  
  
  <xd:doc>
    <xd:desc>Variables from XML teiHeader</xd:desc>
  </xd:doc>
  <xsl:variable name="title"><xsl:value-of select="/TEI/teiHeader/fileDesc/titleStmt/title"/></xsl:variable>
  <xsl:variable name="author"><xsl:value-of select="/TEI/teiHeader/fileDesc/titleStmt/author"/></xsl:variable>
  <xsl:variable name="editor"><xsl:value-of select="/TEI/teiHeader/fileDesc/titleStmt/editor"/></xsl:variable>
  <xsl:param name="targetdirectory">null</xsl:param>
  
  <xd:doc>
    <xd:desc>get versioning numbers</xd:desc>
  </xd:doc>
  <xsl:param name="sourceversion"><xsl:value-of select="/TEI/teiHeader/fileDesc/editionStmt/edition/@n"/></xsl:param>
  <xsl:param name="sourcedate"><xsl:value-of select="/TEI/teiHeader/fileDesc/editionStmt/edition/date/@when"/></xsl:param>
  
  <xd:doc>
    <xd:desc>combined version number should have mirror syntax of an equation x+y source+conversion</xd:desc>
  </xd:doc>
  <xsl:variable name="combinedversionnumber">
    <xsl:value-of select="$sourceversion"/><xsl:text>, </xsl:text>
    <xsl:value-of select="$sourcedate"/>
  </xsl:variable>
  
  
  <xd:doc>
    <xd:desc>Processing variables</xd:desc>
  </xd:doc>
  <xsl:variable name="fs"><xsl:value-of select="/TEI/text/body/div/@xml:id"/></xsl:variable>
  <xsl:variable name="name-list-file">prosopography.xml</xsl:variable>
  <xsl:variable name="work-list-file">bibliography.xml</xsl:variable>
  
  
  
  <xd:doc>
    <xd:desc>Begin: document configuration</xd:desc>
  </xd:doc>  
  
  <xsl:output method="xhtml" encoding="UTF-8" indent="yes"/>
  
  <xd:doc>
    <xd:desc>Swallow multiple whitespace characters.
    </xd:desc>
  </xd:doc>
  <xsl:template match="text()">
    <xsl:value-of select="replace(., '\s+', ' ')"/>
  </xsl:template>
  
  
  
  
  <!--=============================================-->
  <!--             function my:cleantext           -->
  <!--=============================================-->
  <xd:doc>
    <xd:desc>function my:cleantext</xd:desc>
    <xd:desc>Deals with multiple whitespace characters
      and normalizes them.</xd:desc>
    <xd:param name="input"/>
  </xd:doc>
  <xsl:function name="my:cleantext">
    <xsl:param name="input"/>
    <xsl:variable name="step1" select="replace($input, '\n+', ' ')"/>
    <xsl:variable name="step2" select="normalize-space($step1)"/>
    <xsl:sequence select="$step2"/>
  </xsl:function>
  
  
  
  
  <!--=============================================-->
  <!--                main template                -->
  <!--=============================================-->
  <xd:doc>
    <xd:desc>Main template</xd:desc>
  </xd:doc>
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <xsl:attribute name="lang">
        <xsl:value-of select="/TEI/text/@xml:lang"/>
      </xsl:attribute>
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <meta http-equiv="X-UA-Compatible" content="ie=edge"/>
        
        <!--bootstrap css-->
        <link 
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css" 
          rel="stylesheet" 
          integrity="sha384-KyZXEAg3QhqLMpG8r+8fhAXLRk2vvoC2f3B09zVXn8CA5QIVfZOJ3BCsw2P0p/We" 
          crossorigin="anonymous"/>
        
        <!--own css-->
        <link rel="stylesheet" href="xslt-html/css/sm-text.css"/>
        <title><xsl:value-of select="$title"/></title>
      </head>
      <body>
        <div id="main-div" class="container">  
          <xsl:apply-templates select="//body"/> 
        </div>
        
        <!--bootstrap js bundle-->
        <script 
          src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js"
          integrity="sha384-U1DAWAznBHeqEIlVSCgzq+c9gqGAJn5c/t99JyeKa9xxaYpSvHU5awsuZVVFIhvj" 
          crossorigin="anonymous"/>
      </body>
    </html>    
  </xsl:template>
  
  
  
  <!--=============================================-->
  <!--                    <div>                    -->
  <!--=============================================-->
  <xd:doc>
    <xd:desc>
      <xd:p>div[child::head]</xd:p>
      <xd:p>level1 are part divisions</xd:p>
      <xd:p>level2 are chapter divisions</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="div[child::head]">
    <div id="{@xml:id}">
      <xsl:choose>
        <!--parts-->
        <xsl:when test="head[@ana='level1']">
          <h1 class="display-1">
            <xsl:copy-of select="head"/>
          </h1>
        </xsl:when>
        <!--chapters-->
        <xsl:when test="head[@ana='level2']">
          <h2 class="display-2">
            <xsl:copy-of select="head"/>
          </h2>
        </xsl:when>
        <!--sections-->
        <xsl:otherwise>
          <h3 class="display-3">
            <xsl:copy-of select="head"/>
          </h3>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  
  
  
  <!--=============================================-->
  <!--                    <head>                    -->
  <!--=============================================-->
  
  <xd:doc>
    <xd:desc>
      <xd:p>head</xd:p>
      <xd:p>Ignore standalone head</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="head">
    <!-- leave empty  -->
  </xsl:template>
  
  <xd:doc>
    <xd:desc>
      <xd:p>head[note]</xd:p>
      <xd:p>head containing notes</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="head[note]">
    <xsl:apply-templates/>
  </xsl:template>
  
  
  
  <!--=============================================-->
  <!--                    <p>                    -->
  <!--=============================================-->
  
  <xd:doc>
    <xd:desc>
      <xd:p>p</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:template match="p">
    <xsl:variable name="pn"><xsl:number level="any" from="text"/></xsl:variable>
    <xsl:choose>
      <!--special centered paragraph, quasi header h3-->
      <xsl:when test="@ana='h1'">
        <h3 id="{@xml:id}" class="display-3">
          <xsl:apply-templates/>
        </h3>
      </xsl:when>
      <!--special centered paragraph, quasi header h4-->
      <xsl:when test="@ana='h2'">
        <h4 id="{@xml:id}" class="display-4">
          <xsl:apply-templates/>
        </h4>
      </xsl:when>
      <!--indented paragraph-->
      <xsl:when test="@rend='indented'">
        <p id="{@xml:id}" class="sm-indented">
          <span id="pn{$pn}" class="sm-parnum">
            <xsl:number level="any" from="text"/>
            <xsl:text> </xsl:text>
          </span>
          <xsl:apply-templates/>
        </p>
      </xsl:when>
      <!-- all other paragraphs -->
      <xsl:otherwise>
        <p id="{@xml:id}">
          <span id="pn{$pn}" class="sm-parnum">
            <xsl:number level="any" from="text"/>
            <xsl:text> </xsl:text>
          </span>
          <xsl:apply-templates/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <!--  
    <xd:doc>
    <xd:desc>
    <xd:p>p[parent::note]</xd:p>
    <xd:p>paragraphs inside notes</xd:p>
    </xd:desc>
    </xd:doc>
    <xsl:template match="p[parent::note]">
    <xsl:if test="@xml:id">
    <xsl:text>\label{</xsl:text>
    <xsl:value-of select="@xml:id"/>
    <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:if test="@n > 1 and not(@rend='nofirstlineindent')">
    <xsl:text>\par\hspace*{14pt}</xsl:text>
    </xsl:if>
    <xsl:choose>
    <!-\-indented paragraph-\->
    <xsl:when test="@rend='indented'">
    <xsl:text>\begin{indentedpar}</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\end{indentedpar}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
    <xsl:apply-templates/>
    <!-\-only insert \par if next paragraph 
    doesn't include a quote-\->
    <xsl:if test="not(following-sibling::p[descendant::quote])">
    <xsl:text>\par</xsl:text>
    </xsl:if>
    </xsl:otherwise>
    </xsl:choose>
    </xsl:template>
  -->
  
  
  <!-- - - - - - - - - - - - - - - - - - - - -->
  <!--                   <lb>                -->
  <!-- - - - - - - - - - - - - - - - - - - - -->
  
  <xd:doc>
    <xd:desc>
      <xd:p>lb[@type='nonumber']</xd:p>
      <xd:p>line break with no numbering</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="lb[@type='nonumber']" priority="2">
    <!-- Just a line break without numbers.  -->
    <br/>
  </xsl:template>
  
  
  <xd:doc>
    <xd:desc>
      <xd:p>lb[@n='1']</xd:p>
      <xd:p>the first line break in a paragraph</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="lb[@n='1']">
    <br/>
    <!--  Add the line number  -->
    <span class="sm-linum">
      <xsl:value-of select="@n"/>
    </span>
    <xsl:apply-templates/>
  </xsl:template>
  
  
  
  <xd:doc>
    <xd:desc>
      <xd:p>lb</xd:p>
      <xd:p>normal line breaks</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="lb">
    <!--  only for Dialogue:  -->
    <xsl:if test="../@n='4'">
      <!-- Add a line break  -->
      <br></br>
    </xsl:if>
    <!--  Add the line number  -->
    <span class="sm-linum">
      <xsl:value-of select="@n"/>
    </span>
    <xsl:apply-templates/>   
  </xsl:template>
  
  
  
  <!--=============================================-->
  <!--                  <title>                    -->
  <!--=============================================-->
  <xd:doc>
    <xd:desc>
      <xd:p>title</xd:p>
      <xd:p>distinguishes between manuscripts,
        printed editions, and normal titles</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="title">
    <xsl:choose>
      <!--manuscripts-->
      <xsl:when test="@type='ms'">
        <span class="sm-ms-title">
          <xsl:choose>
            <xsl:when test="@ana">
              <xsl:sequence select="my:cleantext(@ana)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </span>
      </xsl:when>
      <!--editions-->
      <xsl:when test="@type='ed'">
        <span class="sm-ed-title">
          <xsl:choose>
            <xsl:when test="@ana">
              <xsl:sequence select="my:cleantext(@ana)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </span>
      </xsl:when>
      <!--normal titles-->  
      <xsl:otherwise>
        <span class="sm-title">
          <xsl:choose>
            <xsl:when test="@ana">
              <xsl:sequence select="my:cleantext(@ana)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  
  <!--=============================================-->
  <!--                 <persName>                  -->
  <!--=============================================-->
  <xd:doc>
    <xd:desc>
      <xd:p>name</xd:p>
      <xd:p>typesets the name using the \Nombre{} command
        and creates an index entry</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="persName|name">
    <span class="sm-name">
      <xsl:choose>
        <xsl:when test="@ana">
          <xsl:sequence select="my:cleantext(@ana)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>
  
  
  
  <!--=============================================-->
  <!--                     <l>                     -->
  <!--=============================================-->
  
  <xd:doc>
    <xd:desc>
      <xd:p>l[not(parent::lg)]</xd:p>
      <xd:p>standalone line</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="l[not(parent::lg)]">
    <xsl:if test="preceding-sibling::l">
      <xsl:text> /
      </xsl:text>
    </xsl:if>
    <xsl:if test="@xml:id">
      <xsl:text>\label{</xsl:text>
      <xsl:value-of select="@xml:id"/>
      <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>
      <xd:p>l[parent::lg]</xd:p>
      <xd:p>lines inside a line group</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="l[parent::lg]">
    <xsl:if test="@xml:id">
      <xsl:text>\label{</xsl:text>
      <xsl:value-of select="@xml:id"/>
      <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:text>\\</xsl:text>
  </xsl:template>
  
  
  <!--begin: todo-->
  <!--=============================================-->
  <!--                    <lg>                     -->
  <!--=============================================-->
  <xd:doc>
    <xd:desc>
      <xd:p>lg</xd:p>
      <xd:p>line group template</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="lg">
    <xsl:text>\begin{myverse}</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\end{myverse}</xsl:text>
  </xsl:template>
  <!--end: todo-->
  
  
  
  <!--=============================================-->
  <!--                     <hi>                    -->
  <!--=============================================--> 
  <xd:doc>
    <xd:desc>
      <xd:p>hi</xd:p>
      <xd:p>highlight template,
        takes care of small caps, bold face,
        superscript text, upshape text,
        and defaults to italic text</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="hi">
    <xsl:choose>
      <xsl:when test="@rend='sc'">
        <span class="sm-small-caps"><xsl:apply-templates/></span>
      </xsl:when>
      <xsl:when test="@rend='bf'">
        <span class="sm-bold"><xsl:apply-templates/></span>
      </xsl:when>
      <xsl:when test="@rend='superscript'">
        <span class="sm-superscript"><xsl:apply-templates/></span>
      </xsl:when>
      <xsl:when test="@rend='upshape'">
        <span class="sm-upshape"><xsl:apply-templates/></span>
      </xsl:when>
      <!-- default choice -->
      <xsl:otherwise>
        <span class="sm-italic"><xsl:apply-templates/></span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <!--=============================================-->
  <!--                     <gap>                   -->
  <!--=============================================-->
  <xd:doc>
    <xd:desc>
      <xd:p>gap</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="gap">
    <span class="sm-elipsis">[…]</span>
  </xsl:template>
  
  
  
  <!--=============================================-->
  <!--                  <supplied>                 -->
  <!--=============================================-->
  <xd:doc>
    <xd:desc>
      <xd:p>supplied</xd:p>
      <xd:p>@ana='eq' produces: [$=$ ]</xd:p>
      <xd:p>@ana='q' uses parenthesis instead of brackets</xd:p>
      <xd:p>@ana='peq' produces: ($=$ )</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="supplied">
    <xsl:choose>
      <xsl:when test="@rend='nobrackets'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="@ana='p' or @ana='peq'">
            <xsl:text>(</xsl:text>
          </xsl:when>  
          <xsl:otherwise>
            <xsl:text>[</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="@ana='p' or @ana='peq'">
          <xsl:text>$=$</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:choose>
          <xsl:when test="@ana='p' or @ana='peq'">
            <xsl:text>)</xsl:text>
          </xsl:when>  
          <xsl:otherwise>
            <xsl:text>]</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <!--  start: todo -->
  <!--=============================================-->
  <!--                    <note>                   -->
  <!--=============================================-->
  <xd:doc>
    <xd:desc>
      <xd:p>note</xd:p>
      <xd:p>inserts a \notenum command
        and then produced the note content</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="note">
    <!--<!-\-check if two notes go together-\->
      <xsl:if test="preceding-sibling::node()[not(self::text()[normalize-space()=''])][1][self::note]">
      <xsl:text>\notesep</xsl:text>
      </xsl:if>-->
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:text>\notenum</xsl:text>
    <!--insert label-->
    <xsl:text>{</xsl:text>
    <xsl:value-of select="@xml:id"/>
    <!--<xsl:value-of select="@xml:id"/>-->
    <xsl:text>}</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>
  
  <!--end: todo-->
  
  
  
  <!--=============================================-->
  <!--                 <caesura>                   -->
  <!--=============================================-->
  <xd:doc>
    <xd:desc>
      <xd:p>caesura</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="caesura">
    <span class="sm-caesura">|</span> 
  </xsl:template>
  
  
  
  <!--=============================================-->
  <!--                   <table>                   -->
  <!--=============================================-->
  
  <xd:doc>
    <xd:desc>
      <xd:p>table</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:template match="table">
    <table id="@table_abbrevgen">
      <xsl:apply-templates/>
    </table>
  </xsl:template>
  
  
  <xd:doc>
    <xd:desc>row</xd:desc>
  </xd:doc>
  <xsl:template match="row">
    <tr>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>cell</xd:desc>
  </xd:doc>
  <xsl:template match="cell">
    <td>  
      <xsl:apply-templates/>
    </td>
  </xsl:template>
  
  
  
  
  <!--=============================================-->
  <!--           miscellaneous elements            -->
  <!--=============================================-->
  
  <xd:doc>
    <xd:desc>
      <xd:p>ab[@ana='nl']</xd:p>
      <xd:p>forced new line</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="ab[@ana='nl']">
    <br></br>
  </xsl:template>
  
  
</xsl:stylesheet>
