<?xml version="1.0"?>

<!DOCTYPE xsl:stylesheet [
  <!ENTITY doNotEdit    "Don't edit: generated by OperationsToWrappers.xsl">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1">
<xsl:output
  method="text"
/>
<xsl:strip-space elements="*"/>

<xsl:include href="OperationToWrapper.xsl"/>

<xsl:template match="Operations">

  <xsl:document href="operations.py"
    omit-xml-declaration="yes"
  >
    <xsl:text># &doNotEdit;
import pcraster._pcraster as _pcraster
import pcraster

def ifthen(arg1, arg2):
  try:
    if isinstance(arg1, str):
      arg1 = _pcraster.readmap(arg1)
    elif (isinstance(arg1, int) or isinstance(arg1, float)) and not arg2.isSpatial():
      arg1 = pcraster.spatial(pcraster.boolean(arg1))
    elif isinstance(arg1, int) or isinstance(arg1, float):
      arg1 = _pcraster._newNonSpatialField(arg1)
    if isinstance(arg2, str):
      arg2 = _pcraster.readmap(arg2)
    elif isinstance(arg2, int) or isinstance(arg2, float):
      arg2 = _pcraster._newNonSpatialField(arg2)
    operator = _pcraster._major2op(_pcraster.MAJOR_CODE.OP_IFTHEN)
    results = []
    _pcraster._rte().pushField(arg1)
    _pcraster._rte().pushField(arg2)
    _pcraster._rte().checkAndExec(operator, 2)
    results.append(_pcraster._rte().releasePopField())
    return results[0]
  except RuntimeError as exception:
    raise RuntimeError("ifthen: %s" % (str(exception)))
def ifthenelse(arg1, arg2, arg3):
  try:
    if isinstance(arg1, str):
      arg1 = _pcraster.readmap(arg1)
    elif isinstance(arg1, int) or isinstance(arg1, float):
      arg1 = _pcraster._newNonSpatialField(arg1)
    if isinstance(arg2, str):
      arg2 = _pcraster.readmap(arg2)
    elif isinstance(arg2, int) or isinstance(arg2, float):
      arg2 = _pcraster._newNonSpatialField(arg2)
    if isinstance(arg3, str):
      arg3 = _pcraster.readmap(arg3)
    elif isinstance(arg3, int) or isinstance(arg3, float):
      arg3 = _pcraster._newNonSpatialField(arg3)
    operator = _pcraster._major2op(_pcraster.MAJOR_CODE.OP_IFTHENELSE)
    results = []
    _pcraster._rte().pushField(arg1)
    _pcraster._rte().pushField(arg2)
    _pcraster._rte().pushField(arg3)
    _pcraster._rte().checkAndExec(operator, 3)
    results.append(_pcraster._rte().releasePopField())
    return results[0]
  except RuntimeError as exception:
    raise RuntimeError("ifthenelse: %s" % (str(exception)))
</xsl:text>
<!--
    <xsl:apply-templates select="Operation[@syntax!='None'] | Operation[@name='if']" mode="py"/>
    -->
    <!--<xsl:for-each select="Operation[@syntax!='None'] | Operation[@name='if']">-->
    <xsl:for-each select="Operation[@syntax!='None']">
      <xsl:call-template name="pythonOperation">
        <xsl:with-param name="operation" select="."/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:document>

  <xsl:document href="operations.inc"
    omit-xml-declaration="yes"
  >
    <xsl:text disable-output-escaping="yes">// &doNotEdit;
#ifndef INCLUDED_MAJOR_OP
#include "major_op.h"
#define INCLUDED_MAJOR_OP
#endif
enum_&lt;MAJOR_CODE&gt;(module, "MAJOR_CODE")&#xA;</xsl:text>
    <xsl:for-each select="Operation[@syntax!='None'] | Operation[@name='if']">
      <xsl:variable name="operation" select="."/>
      <xsl:for-each select="$operation/Result">
        <xsl:variable name="result" select="."/>

        <xsl:variable name="opcode">
          <xsl:call-template name="opcode">
            <xsl:with-param name="operation" select="$operation"/>
            <xsl:with-param name="result" select="$result"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="concat('  .value(&quot;', $opcode, '&quot;, ', $opcode, ')&#xA;')"/>
      </xsl:for-each>
    </xsl:for-each>
    <xsl:text> ;&#xA;</xsl:text>
  </xsl:document>
</xsl:template>

</xsl:stylesheet>
