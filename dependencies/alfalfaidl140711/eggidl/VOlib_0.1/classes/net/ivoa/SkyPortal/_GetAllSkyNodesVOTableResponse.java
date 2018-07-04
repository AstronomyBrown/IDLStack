/**
 * _GetAllSkyNodesVOTableResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.SkyPortal;

public class _GetAllSkyNodesVOTableResponse  implements java.io.Serializable {
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.VOTABLE getAllSkyNodesVOTableResult;

    public _GetAllSkyNodesVOTableResponse() {
    }


    /**
     * Gets the getAllSkyNodesVOTableResult value for this _GetAllSkyNodesVOTableResponse.
     * 
     * @return getAllSkyNodesVOTableResult
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.VOTABLE getGetAllSkyNodesVOTableResult() {
        return getAllSkyNodesVOTableResult;
    }


    /**
     * Sets the getAllSkyNodesVOTableResult value for this _GetAllSkyNodesVOTableResponse.
     * 
     * @param getAllSkyNodesVOTableResult
     */
    public void setGetAllSkyNodesVOTableResult(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.VOTABLE getAllSkyNodesVOTableResult) {
        this.getAllSkyNodesVOTableResult = getAllSkyNodesVOTableResult;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof _GetAllSkyNodesVOTableResponse)) return false;
        _GetAllSkyNodesVOTableResponse other = (_GetAllSkyNodesVOTableResponse) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.getAllSkyNodesVOTableResult==null && other.getGetAllSkyNodesVOTableResult()==null) || 
             (this.getAllSkyNodesVOTableResult!=null &&
              this.getAllSkyNodesVOTableResult.equals(other.getGetAllSkyNodesVOTableResult())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getGetAllSkyNodesVOTableResult() != null) {
            _hashCode += getGetAllSkyNodesVOTableResult().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(_GetAllSkyNodesVOTableResponse.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetAllSkyNodesVOTableResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("getAllSkyNodesVOTableResult");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "GetAllSkyNodesVOTableResult"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "VOTABLE"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
