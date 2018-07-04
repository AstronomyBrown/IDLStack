/**
 * ConeSearch.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.ConeSearch.v0_3;

public class ConeSearch  extends net.ivoa.www.xml.VODataService.v0_5.TabularSkyService  implements java.io.Serializable {
    private net.ivoa.www.xml.ConeSearch.v0_3.ConeSearchCapability capability;

    public ConeSearch() {
    }


    /**
     * Gets the capability value for this ConeSearch.
     * 
     * @return capability
     */
    public net.ivoa.www.xml.ConeSearch.v0_3.ConeSearchCapability getCapability() {
        return capability;
    }


    /**
     * Sets the capability value for this ConeSearch.
     * 
     * @param capability
     */
    public void setCapability(net.ivoa.www.xml.ConeSearch.v0_3.ConeSearchCapability capability) {
        this.capability = capability;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ConeSearch)) return false;
        ConeSearch other = (ConeSearch) obj;
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
        new org.apache.axis.description.TypeDesc(ConeSearch.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ConeSearch/v0.3", "ConeSearch"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("capability");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ConeSearch/v0.3", "capability"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ConeSearch/v0.3", "ConeSearchCapability"));
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
