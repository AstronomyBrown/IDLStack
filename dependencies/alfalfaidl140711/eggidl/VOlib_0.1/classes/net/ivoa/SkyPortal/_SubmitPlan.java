/**
 * _SubmitPlan.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.SkyPortal;

public class _SubmitPlan  implements java.io.Serializable {
    private net.ivoa.SkyPortal.ExecPlan ep;

    public _SubmitPlan() {
    }


    /**
     * Gets the ep value for this _SubmitPlan.
     * 
     * @return ep
     */
    public net.ivoa.SkyPortal.ExecPlan getEp() {
        return ep;
    }


    /**
     * Sets the ep value for this _SubmitPlan.
     * 
     * @param ep
     */
    public void setEp(net.ivoa.SkyPortal.ExecPlan ep) {
        this.ep = ep;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof _SubmitPlan)) return false;
        _SubmitPlan other = (_SubmitPlan) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.ep==null && other.getEp()==null) || 
             (this.ep!=null &&
              this.ep.equals(other.getEp())));
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
        if (getEp() != null) {
            _hashCode += getEp().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(_SubmitPlan.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">SubmitPlan"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ep");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ep"));
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
