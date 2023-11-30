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
      <xd:p>This file contains templates dealing with
        quotes and citations.</xd:p>
    </xd:desc>
  </xd:doc>  
  
  
  
  <!--=============================================-->
  <!--                     <foreign>               -->
  <!--                     <mentioned>             -->
  <!--                     <gloss>                 -->
  <!--                     <q[not(parent::cit)]>   -->
  <!--=============================================-->
  <xd:doc>
    <xd:desc>
      <xd:p>template to deal with standalone quotes</xd:p>
      <xd:ul>
        <xd:li>#1: lang</xd:li>
        <xd:li>#2: label</xd:li>
        <xd:li>#3: text</xd:li> 
      </xd:ul>
    </xd:desc>
  </xd:doc>
  <xsl:template match="foreign | mentioned | gloss | q[not(parent::cit)]">
    <q>
      <xsl:choose>
        <xsl:when test="@xml:lang or name(.)='foreign'">
          <xsl:attribute name="class">sm-foreign</xsl:attribute>
          <xsl:attribute name="lang">
            <xsl:value-of select="@xml:lang"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="lang">es</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <!--      -->
      <xsl:if test="@xml:id">
        <xsl:attribute name="id">
          <xsl:value-of select="@xml:id"/>
        </xsl:attribute>
      </xsl:if>
      <!--      -->
      <xsl:if test="@ana='lexeme'">
        <xsl:attribute name="class">sm-lexeme</xsl:attribute>
      </xsl:if>
    </q>
  </xsl:template>
  
  
  

  <!--=============================================-->
  <!--                    <cit>                    -->
  <!--=============================================-->
  <!--cit / quote / q / ref-->
  <xd:doc>
    <xd:desc>
      <xd:p>citations</xd:p>
      <xd:p>cit[child::quote]</xd:p>
      <xd:ul>
        <xd:li>#1: language</xd:li>
        <xd:li>#2: label</xd:li>
        <xd:li>#3: original language text</xd:li>
        <xd:li>#4: translation text</xd:li>
        <xd:li>#5: reference</xd:li>
      </xd:ul>
    </xd:desc>
  </xd:doc>
  <xsl:template match="cit[child::quote]">
    <xsl:if test="quote[@xml:id]">
      <xsl:value-of select="quote/@xml:id"/>
    </xsl:if>
    <!--insert original quote-->
    <xsl:apply-templates select="quote"/>
    <xsl:if test="q">
      <!--insert comma-->
      <xsl:text>,</xsl:text>
      <!--insert q trans.-->
      <xsl:apply-templates select="q"/>
    </xsl:if>
    <!--insert ref-->
    <xsl:if test="ref">
      <xsl:text>(</xsl:text>
      <xsl:apply-templates select="ref"/>
      <xsl:text>)</xsl:text>
    </xsl:if>
  </xsl:template>
  
  
  
  <xd:doc>
    <xd:desc>
      <xd:p>citations</xd:p>
      <xd:p>cit[not(child::quote)]</xd:p>
      <xd:p>citation without quote</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="cit[not(child::quote)]">
    <xsl:apply-templates/>
  </xsl:template>
  
  
  
  <xd:doc>
    <xd:desc>quote</xd:desc>
  </xd:doc>
  <xsl:template match="quote">
    <xsl:choose>
      <xsl:when test="@ana='verse'">
        <blockquote id="{@xml:id}">
          <xsl:choose>
            <xsl:when test="@xml:lang">
              <xsl:attribute name="lang">
                <xsl:value-of select="@xml:lang"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="lang">es</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates/>
        </blockquote>
      </xsl:when>
      <xsl:otherwise>
        <q id="{@xml:id}">
          <xsl:choose>
            <xsl:when test="@xml:lang">
              <xsl:attribute name="lang">
                <xsl:value-of select="@xml:lang"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="lang">es</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates/>
        </q>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  

  
  
  
</xsl:stylesheet>
