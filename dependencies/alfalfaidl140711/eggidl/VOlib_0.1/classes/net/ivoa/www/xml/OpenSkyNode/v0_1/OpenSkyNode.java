/**
 * OpenSkyNode.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.OpenSkyNode.v0_1;

public class OpenSkyNode  extends net.ivoa.www.xml.VODataService.v0_5.TabularSkyService  implements java.io.Serializable {
    private net.ivoa.www.xml.OpenSkyNode.v0_1.OSNCapability capability;

    public OpenSkyNode() {
    }


    /**
     * Gets the capability value for this OpenSkyNode.
     * 
     * @return capability
     */
    public net.ivoa.www.xml.OpenSkyNode.v0_1.OSNCapability getCapability() {
        return capability;
    }


    /**
     * Sets the capability value for this OpenSkyNode.
     * 
     * @param capability
     */
    public void setCapability(net.ivoa.www.xml.OpenSkyNode.v0_1.OSNCapability capability) {
        this.capability = capability;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof OpenSkyNode)) return false;
        OpenSkyNode other = (OpenSkyNode) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.capability==null && other.getCapability()==null) || 
             (this.capability!=null &&
              this.capability.equals(other.getCapability())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = super.hashCode();
        if (getCapability() != null) {
            _hashCode += getCapability().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(OpenSkyNode.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/OpenSkyNode/v0.1", "OpenSkyNode"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("capability");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/OpenSkyNode/v0.1", "capability"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/OpenSkyNode/v0.1", "OSNCapability"));
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
