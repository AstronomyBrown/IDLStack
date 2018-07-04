/**
 * _GetColumnsResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.SkyPortal;

public class _GetColumnsResponse  implements java.io.Serializable {
    private net.ivoa.SkyPortal.ArrayOfString getColumnsResult;

    public _GetColumnsResponse() {
    }


    /**
     * Gets the getColumnsResult value for this _GetColumnsResponse.
     * 
     * @return getColumnsResult
     */
    public net.ivoa.SkyPortal.ArrayOfString getGetColumnsResult() {
        return getColumnsResult;
    }


    /**
     * Sets the getColumnsResult value for this _GetColumnsResponse.
     * 
     * @param getColumnsResult
     */
    public void setGetColumnsResult(net.ivoa.SkyPortal.ArrayOfString getColumnsResult) {
        this.getColumnsResult = getColumnsResult;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof _GetColumnsResponse)) return false;
        _GetColumnsResponse other = (_GetColumnsResponse) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.getColumnsResult==null && other.getGetColumnsResult()==null) || 
             (this.getColumnsResult!=null &&
              this.getColumnsResult.equals(other.getGetColumnsResult())));
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
        if (getGetColumnsResult() != null) {
            _hashCode += getGetColumnsResult().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(_GetColumnsResponse.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetColumnsResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("getColumnsResult");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetColumnsResult"));
        elemField.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ArrayOfString"));
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
