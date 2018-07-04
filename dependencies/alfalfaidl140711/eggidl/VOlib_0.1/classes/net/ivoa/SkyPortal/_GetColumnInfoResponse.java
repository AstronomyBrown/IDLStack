/**
 * _GetColumnInfoResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.SkyPortal;

public class _GetColumnInfoResponse  implements java.io.Serializable {
    private net.ivoa.SkyPortal.MetaColumn getColumnInfoResult;

    public _GetColumnInfoResponse() {
    }


    /**
     * Gets the getColumnInfoResult value for this _GetColumnInfoResponse.
     * 
     * @return getColumnInfoResult
     */
    public net.ivoa.SkyPortal.MetaColumn getGetColumnInfoResult() {
        return getColumnInfoResult;
    }


    /**
     * Sets the getColumnInfoResult value for this _GetColumnInfoResponse.
     * 
     * @param getColumnInfoResult
     */
    public void setGetColumnInfoResult(net.ivoa.SkyPortal.MetaColumn getColumnInfoResult) {
        this.getColumnInfoResult = getColumnInfoResult;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof _GetColumnInfoResponse)) return false;
        _GetColumnInfoResponse other = (_GetColumnInfoResponse) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.getColumnInfoResult==null && other.getGetColumnInfoResult()==null) || 
             (this.getColumnInfoResult!=null &&
              this.getColumnInfoResult.equals(other.getGetColumnInfoResult())));
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
        if (getGetColumnInfoResult() != null) {
            _hashCode += getGetColumnInfoResult().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(_GetColumnInfoResponse.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetColumnInfoResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("getColumnInfoResult");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetColumnInfoResult"));
        elemField.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "MetaColumn"));
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
