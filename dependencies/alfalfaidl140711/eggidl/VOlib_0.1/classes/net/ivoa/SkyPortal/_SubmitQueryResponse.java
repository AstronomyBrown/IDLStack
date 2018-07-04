/**
 * _SubmitQueryResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.SkyPortal;

public class _SubmitQueryResponse  implements java.io.Serializable {
    private net.ivoa.SkyPortal.VOData submitQueryResult;

    public _SubmitQueryResponse() {
    }


    /**
     * Gets the submitQueryResult value for this _SubmitQueryResponse.
     * 
     * @return submitQueryResult
     */
    public net.ivoa.SkyPortal.VOData getSubmitQueryResult() {
        return submitQueryResult;
    }


    /**
     * Sets the submitQueryResult value for this _SubmitQueryResponse.
     * 
     * @param submitQueryResult
     */
    public void setSubmitQueryResult(net.ivoa.SkyPortal.VOData submitQueryResult) {
        this.submitQueryResult = submitQueryResult;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof _SubmitQueryResponse)) return false;
        _SubmitQueryResponse other = (_SubmitQueryResponse) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.submitQueryResult==null && other.getSubmitQueryResult()==null) || 
             (this.submitQueryResult!=null &&
              this.submitQueryResult.equals(other.getSubmitQueryResult())));
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
        if (getSubmitQueryResult() != null) {
            _hashCode += getSubmitQueryResult().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(_SubmitQueryResponse.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">SubmitQueryResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("submitQueryResult");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "SubmitQueryResult"));
        elemField.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "VOData"));
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
