/**
 * _GetTablesResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.SkyPortal;

public class _GetTablesResponse  implements java.io.Serializable {
    private net.ivoa.SkyPortal.ArrayOfMetaTable getTablesResult;

    public _GetTablesResponse() {
    }


    /**
     * Gets the getTablesResult value for this _GetTablesResponse.
     * 
     * @return getTablesResult
     */
    public net.ivoa.SkyPortal.ArrayOfMetaTable getGetTablesResult() {
        return getTablesResult;
    }


    /**
     * Sets the getTablesResult value for this _GetTablesResponse.
     * 
     * @param getTablesResult
     */
    public void setGetTablesResult(net.ivoa.SkyPortal.ArrayOfMetaTable getTablesResult) {
        this.getTablesResult = getTablesResult;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof _GetTablesResponse)) return false;
        _GetTablesResponse other = (_GetTablesResponse) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.getTablesResult==null && other.getGetTablesResult()==null) || 
             (this.getTablesResult!=null &&
              this.getTablesResult.equals(other.getGetTablesResult())));
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
        if (getGetTablesResult() != null) {
            _hashCode += getGetTablesResult().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(_GetTablesResponse.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetTablesResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("getTablesResult");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetTablesResult"));
        elemField.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ArrayOfMetaTable"));
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
