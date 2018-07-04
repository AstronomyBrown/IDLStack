/**
 * _GetMetaColumnsResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.SkyPortal;

public class _GetMetaColumnsResponse  implements java.io.Serializable {
    private net.ivoa.SkyPortal.ArrayOfMetaColumn getMetaColumnsResult;

    public _GetMetaColumnsResponse() {
    }


    /**
     * Gets the getMetaColumnsResult value for this _GetMetaColumnsResponse.
     * 
     * @return getMetaColumnsResult
     */
    public net.ivoa.SkyPortal.ArrayOfMetaColumn getGetMetaColumnsResult() {
        return getMetaColumnsResult;
    }


    /**
     * Sets the getMetaColumnsResult value for this _GetMetaColumnsResponse.
     * 
     * @param getMetaColumnsResult
     */
    public void setGetMetaColumnsResult(net.ivoa.SkyPortal.ArrayOfMetaColumn getMetaColumnsResult) {
        this.getMetaColumnsResult = getMetaColumnsResult;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof _GetMetaColumnsResponse)) return false;
        _GetMetaColumnsResponse other = (_GetMetaColumnsResponse) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.getMetaColumnsResult==null && other.getGetMetaColumnsResult()==null) || 
             (this.getMetaColumnsResult!=null &&
              this.getMetaColumnsResult.equals(other.getGetMetaColumnsResult())));
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
        if (getGetMetaColumnsResult() != null) {
            _hashCode += getGetMetaColumnsResult().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(_GetMetaColumnsResponse.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetMetaColumnsResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("getMetaColumnsResult");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetMetaColumnsResult"));
        elemField.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ArrayOfMetaColumn"));
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
