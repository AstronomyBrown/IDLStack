/**
 * _SubmitPlanResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.SkyPortal;

public class _SubmitPlanResponse  implements java.io.Serializable {
    private net.ivoa.SkyPortal.VOData submitPlanResult;

    public _SubmitPlanResponse() {
    }


    /**
     * Gets the submitPlanResult value for this _SubmitPlanResponse.
     * 
     * @return submitPlanResult
     */
    public net.ivoa.SkyPortal.VOData getSubmitPlanResult() {
        return submitPlanResult;
    }


    /**
     * Sets the submitPlanResult value for this _SubmitPlanResponse.
     * 
     * @param submitPlanResult
     */
    public void setSubmitPlanResult(net.ivoa.SkyPortal.VOData submitPlanResult) {
        this.submitPlanResult = submitPlanResult;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof _SubmitPlanResponse)) return false;
        _SubmitPlanResponse other = (_SubmitPlanResponse) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.submitPlanResult==null && other.getSubmitPlanResult()==null) || 
             (this.submitPlanResult!=null &&
              this.submitPlanResult.equals(other.getSubmitPlanResult())));
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
        if (getSubmitPlanResult() != null) {
            _hashCode += getSubmitPlanResult().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(_SubmitPlanResponse.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">SubmitPlanResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("submitPlanResult");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "SubmitPlanResult"));
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
