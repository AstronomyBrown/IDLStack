/**
 * _MakePlanResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.SkyPortal;

public class _MakePlanResponse  implements java.io.Serializable {
    private net.ivoa.SkyPortal.ExecPlan makePlanResult;

    public _MakePlanResponse() {
    }


    /**
     * Gets the makePlanResult value for this _MakePlanResponse.
     * 
     * @return makePlanResult
     */
    public net.ivoa.SkyPortal.ExecPlan getMakePlanResult() {
        return makePlanResult;
    }


    /**
     * Sets the makePlanResult value for this _MakePlanResponse.
     * 
     * @param makePlanResult
     */
    public void setMakePlanResult(net.ivoa.SkyPortal.ExecPlan makePlanResult) {
        this.makePlanResult = makePlanResult;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof _MakePlanResponse)) return false;
        _MakePlanResponse other = (_MakePlanResponse) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.makePlanResult==null && other.getMakePlanResult()==null) || 
             (this.makePlanResult!=null &&
              this.makePlanResult.equals(other.getMakePlanResult())));
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
        if (getMakePlanResult() != null) {
            _hashCode += getMakePlanResult().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(_MakePlanResponse.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">MakePlanResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("makePlanResult");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "MakePlanResult"));
        elemField.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ExecPlan"));
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
