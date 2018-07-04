/**
 * _GetMetaTablesResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.SkyPortal;

public class _GetMetaTablesResponse  implements java.io.Serializable {
    private net.ivoa.SkyPortal.ArrayOfMetaTable getMetaTablesResult;

    public _GetMetaTablesResponse() {
    }


    /**
     * Gets the getMetaTablesResult value for this _GetMetaTablesResponse.
     * 
     * @return getMetaTablesResult
     */
    public net.ivoa.SkyPortal.ArrayOfMetaTable getGetMetaTablesResult() {
        return getMetaTablesResult;
    }


    /**
     * Sets the getMetaTablesResult value for this _GetMetaTablesResponse.
     * 
     * @param getMetaTablesResult
     */
    public void setGetMetaTablesResult(net.ivoa.SkyPortal.ArrayOfMetaTable getMetaTablesResult) {
        this.getMetaTablesResult = getMetaTablesResult;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof _GetMetaTablesResponse)) return false;
        _GetMetaTablesResponse other = (_GetMetaTablesResponse) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.getMetaTablesResult==null && other.getGetMetaTablesResult()==null) || 
             (this.getMetaTablesResult!=null &&
              this.getMetaTablesResult.equals(other.getGetMetaTablesResult())));
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
        if (getGetMetaTablesResult() != null) {
            _hashCode += getGetMetaTablesResult().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(_GetMetaTablesResponse.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetMetaTablesResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("getMetaTablesResult");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetMetaTablesResult"));
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
